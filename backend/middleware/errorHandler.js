const errorHandler = (err, req, res, next) => {
  console.error('Error:', err);

  // Default error
  let error = {
    success: false,
    message: 'Terjadi kesalahan server'
  };

  // MySQL errors
  if (err.code === 'ER_DUP_ENTRY') {
    error.message = 'Data sudah ada';
    return res.status(400).json(error);
  }

  if (err.code === 'ER_NO_REFERENCED_ROW_2') {
    error.message = 'Data referensi tidak ditemukan';
    return res.status(400).json(error);
  }

  // Validation errors
  if (err.name === 'ValidationError') {
    error.message = err.message;
    return res.status(400).json(error);
  }

  // JWT errors
  if (err.name === 'JsonWebTokenError') {
    error.message = 'Token tidak valid';
    return res.status(401).json(error);
  }

  if (err.name === 'TokenExpiredError') {
    error.message = 'Token sudah expired';
    return res.status(401).json(error);
  }

  // Custom errors
  if (err.statusCode) {
    error.message = err.message;
    return res.status(err.statusCode).json(error);
  }

  // Default server error
  res.status(500).json(error);
};

module.exports = { errorHandler };