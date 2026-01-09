// Test script untuk create tugas
const axios = require('axios');

const baseUrl = 'http://localhost:3000/api';

async function testCreateTugas() {
  try {
    console.log('🧪 Testing TUGASKU API...\n');

    // 1. Test health check
    console.log('1. Testing health check...');
    const healthResponse = await axios.get(`${baseUrl}/health`);
    console.log('✅ Health check:', healthResponse.data);

    // 2. Register test user
    console.log('\n2. Registering test user...');
    try {
      const registerResponse = await axios.post(`${baseUrl}/auth/register`, {
        email: 'test@tugasku.com',
        password: '123456',
        name: 'Test User'
      });
      console.log('✅ Register success:', registerResponse.data);
    } catch (error) {
      if (error.response?.status === 400 && error.response?.data?.message === 'Email sudah terdaftar') {
        console.log('ℹ️ User already exists, continuing...');
      } else {
        throw error;
      }
    }

    // 3. Login
    console.log('\n3. Logging in...');
    const loginResponse = await axios.post(`${baseUrl}/auth/login`, {
      email: 'test@tugasku.com',
      password: '123456'
    });
    console.log('✅ Login success:', loginResponse.data);
    
    const token = loginResponse.data.data.token;
    console.log('🔑 Token:', token.substring(0, 20) + '...');

    // 4. Create tugas with correct format
    console.log('\n4. Creating tugas...');
    const tugasData = {
      judul: 'Test Praktikum',
      mata_kuliah: 'PPB',
      jenis: 'praktikum',
      deadline: '2026-01-15', // Format YYYY-MM-DD
      status: 'belum',
      catatan: 'Test catatan'
    };

    console.log('📝 Tugas data:', tugasData);

    const createResponse = await axios.post(`${baseUrl}/tugas`, tugasData, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    });
    console.log('✅ Create tugas success:', createResponse.data);

    // 5. Get all tugas
    console.log('\n5. Getting all tugas...');
    const getTugasResponse = await axios.get(`${baseUrl}/tugas`, {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    console.log('✅ Get tugas success:', getTugasResponse.data);

    console.log('\n🎉 All tests passed!');

  } catch (error) {
    console.error('❌ Test failed:', error.response?.data || error.message);
    if (error.response?.data?.errors) {
      console.error('Validation errors:', error.response.data.errors);
    }
  }
}

testCreateTugas();