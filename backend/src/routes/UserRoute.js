const express = require('express')

const router = express.Router()
const {
    Login,
    GetUserAll,
    GetUserById,
    CreateUser,
    UpdateUser,
    DeleteUser
} = require('../controllers/UserController')

router.post('/login', Login)
router.get('/',  GetUserAll)
router.get('/:id', GetUserById)
router.post('/',  CreateUser)
router.put('/:id', UpdateUser)
router.delete('/:id',  DeleteUser)

module.exports = router