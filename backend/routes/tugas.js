const express = require('express');
const { body, validationResult } = require('express-validator');
const db = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// Apply authentication to all routes
router.use(authenticateToken);

// Get all tugas for authenticated user
router.get('/', async (req, res, next) => {
  try {
    const [tugas] = await db.execute(
      `SELECT id, judul, mata_kuliah, jenis, deadline, status, catatan, 
       created_at, updated_at 
       FROM tugas 
       WHERE user_id = ? 
       ORDER BY deadline ASC, created_at DESC`,
      [req.user.id]
    );

    res.json({
      success: true,
      message: 'Data tugas berhasil diambil',
      data: tugas
    });

  } catch (error) {
    next(error);
  }
});

// Get single tugas by ID
router.get('/:id', async (req, res, next) => {
  try {
    const { id } = req.params;

    const [tugas] = await db.execute(
      `SELECT id, judul, mata_kuliah, jenis, deadline, status, catatan, 
       created_at, updated_at 
       FROM tugas 
       WHERE id = ? AND user_id = ?`,
      [id, req.user.id]
    );

    if (tugas.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Tugas tidak ditemukan'
      });
    }

    res.json({
      success: true,
      message: 'Data tugas berhasil diambil',
      data: tugas[0]
    });

  } catch (error) {
    next(error);
  }
});

// Create new tugas
router.post('/', [
  body('judul').notEmpty().withMessage('Judul tugas tidak boleh kosong'),
  body('mata_kuliah').notEmpty().withMessage('Mata kuliah tidak boleh kosong'),
  body('jenis').isIn(['praktikum', 'teori', 'lainnya']).withMessage('Jenis tugas tidak valid'),
  body('deadline').matches(/^\d{4}-\d{2}-\d{2}$/).withMessage('Format deadline harus YYYY-MM-DD'),
  body('status').optional().isIn(['belum', 'selesai']).withMessage('Status tidak valid')
], async (req, res, next) => {
  try {
    // Check validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Data tidak valid',
        errors: errors.array()
      });
    }

    const { judul, mata_kuliah, jenis, deadline, status = 'belum', catatan = '' } = req.body;

    const [result] = await db.execute(
      `INSERT INTO tugas (user_id, judul, mata_kuliah, jenis, deadline, status, catatan) 
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [req.user.id, judul, mata_kuliah, jenis, deadline, status, catatan]
    );

    // Get the created tugas
    const [newTugas] = await db.execute(
      `SELECT id, judul, mata_kuliah, jenis, deadline, status, catatan, 
       created_at, updated_at 
       FROM tugas 
       WHERE id = ?`,
      [result.insertId]
    );

    res.status(201).json({
      success: true,
      message: 'Tugas berhasil ditambahkan',
      data: newTugas[0]
    });

  } catch (error) {
    next(error);
  }
});

// Update tugas
router.put('/:id', [
  body('judul').optional().notEmpty().withMessage('Judul tugas tidak boleh kosong'),
  body('mata_kuliah').optional().notEmpty().withMessage('Mata kuliah tidak boleh kosong'),
  body('jenis').optional().isIn(['praktikum', 'teori', 'lainnya']).withMessage('Jenis tugas tidak valid'),
  body('deadline').optional().matches(/^\d{4}-\d{2}-\d{2}$/).withMessage('Format deadline harus YYYY-MM-DD'),
  body('status').optional().isIn(['belum', 'selesai']).withMessage('Status tidak valid')
], async (req, res, next) => {
  try {
    // Check validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Data tidak valid',
        errors: errors.array()
      });
    }

    const { id } = req.params;
    const { judul, mata_kuliah, jenis, deadline, status, catatan } = req.body;

    // Check if tugas exists and belongs to user
    const [existingTugas] = await db.execute(
      'SELECT id FROM tugas WHERE id = ? AND user_id = ?',
      [id, req.user.id]
    );

    if (existingTugas.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Tugas tidak ditemukan'
      });
    }

    // Build dynamic update query
    const updateFields = [];
    const updateValues = [];

    if (judul !== undefined) {
      updateFields.push('judul = ?');
      updateValues.push(judul);
    }
    if (mata_kuliah !== undefined) {
      updateFields.push('mata_kuliah = ?');
      updateValues.push(mata_kuliah);
    }
    if (jenis !== undefined) {
      updateFields.push('jenis = ?');
      updateValues.push(jenis);
    }
    if (deadline !== undefined) {
      updateFields.push('deadline = ?');
      updateValues.push(deadline);
    }
    if (status !== undefined) {
      updateFields.push('status = ?');
      updateValues.push(status);
    }
    if (catatan !== undefined) {
      updateFields.push('catatan = ?');
      updateValues.push(catatan);
    }

    if (updateFields.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Tidak ada data yang diupdate'
      });
    }

    updateValues.push(id, req.user.id);

    await db.execute(
      `UPDATE tugas SET ${updateFields.join(', ')} WHERE id = ? AND user_id = ?`,
      updateValues
    );

    // Get updated tugas
    const [updatedTugas] = await db.execute(
      `SELECT id, judul, mata_kuliah, jenis, deadline, status, catatan, 
       created_at, updated_at 
       FROM tugas 
       WHERE id = ?`,
      [id]
    );

    res.json({
      success: true,
      message: 'Tugas berhasil diupdate',
      data: updatedTugas[0]
    });

  } catch (error) {
    next(error);
  }
});

// Delete tugas
router.delete('/:id', async (req, res, next) => {
  try {
    const { id } = req.params;

    // Check if tugas exists and belongs to user
    const [existingTugas] = await db.execute(
      'SELECT id FROM tugas WHERE id = ? AND user_id = ?',
      [id, req.user.id]
    );

    if (existingTugas.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Tugas tidak ditemukan'
      });
    }

    await db.execute(
      'DELETE FROM tugas WHERE id = ? AND user_id = ?',
      [id, req.user.id]
    );

    res.json({
      success: true,
      message: 'Tugas berhasil dihapus'
    });

  } catch (error) {
    next(error);
  }
});

// Toggle tugas status
router.patch('/:id/toggle-status', async (req, res, next) => {
  try {
    const { id } = req.params;

    // Get current status
    const [currentTugas] = await db.execute(
      'SELECT status FROM tugas WHERE id = ? AND user_id = ?',
      [id, req.user.id]
    );

    if (currentTugas.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Tugas tidak ditemukan'
      });
    }

    const newStatus = currentTugas[0].status === 'selesai' ? 'belum' : 'selesai';

    await db.execute(
      'UPDATE tugas SET status = ? WHERE id = ? AND user_id = ?',
      [newStatus, id, req.user.id]
    );

    // Get updated tugas
    const [updatedTugas] = await db.execute(
      `SELECT id, judul, mata_kuliah, jenis, deadline, status, catatan, 
       created_at, updated_at 
       FROM tugas 
       WHERE id = ?`,
      [id]
    );

    res.json({
      success: true,
      message: `Status tugas berhasil diubah menjadi ${newStatus}`,
      data: updatedTugas[0]
    });

  } catch (error) {
    next(error);
  }
});

module.exports = router;