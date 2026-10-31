const express = require('express');
const router = express.Router()

const Siswa = require('./SiswaRoute')
const User = require('./UserRoute')

router.use('/siswa', Siswa)
router.use('/user', User)

module.exports = router