const db = require('../../config/database')
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const JWT_SECRET = '8fK2mP9xQ7vL4nR6sT1zW5yU3aB0cD'


class UserController {

    static async Login(req, res) {
        try {
            const data = req.body
            const sql = 'SELECT * FROM user where email = ?'

            const [result] = await db.promise().query(sql, [data.email])

            if (result.length === 0) {
                return res.status(400).json({
                    status: 400,
                    message: "Email atau Password Salah"
                })
            }

            const user = result[0]

            const passwordMatch = await bcrypt.compare(data.password, user.password)

            if (!passwordMatch) {
                return res.status(400).json({
                    status: 400,
                    message: "Email atau Password salah"
                })
            }

            const token = jwt.sign(
                {
                    id: user.id,
                    email: user.email
                },
                JWT_SECRET,
                {
                    expiresIn: '1h'
                }
            )

            return res.status(200).json({
                status: 200,
                message: 'Berhasil Login',
                ...data,
                token
            })
        } catch (error) {
            return res.status(500).json({
                status: 500,
                message: error.message

            })
        }
    }

    static async GetUserAll(req, res) {
        try {
            const sql = 'SELECT * FROM user'

            const [result] = await db.promise().query(sql)

            res.json(result)

        } catch (error) {
            console.log(error)

            res.status(500).json({
                status: "500",
                message: "Terjadi kesalahan pada server"
            })
        }
    }


    static async GetUserById(req, res) {
        try {
            const id = req.params.id

            const sql = 'SELECT * FROM user WHERE id = ?'

            const [result] = await db.promise().query(sql, [id])

            if (result.length === 0) {
                return res.status(404).json({
                    status: "404",
                    message: "User tidak ditemukan"
                })
            }

            res.json(result[0])

        } catch (error) {
            console.log(error)

            res.status(500).json({
                status: "500",
                message: "Terjadi kesalahan pada server"
            })
        }
    }


    static async CreateUser(req, res) {
        try {
            const data = req.body
            const { password, ...UserData } = data

            // Validasi
            if (!data.name || !data.email) {
                return res.status(400).json({
                    status: "400",
                    message: "Name dan email wajib diisi"
                })
            }

            const sql = 'INSERT INTO user (name, email, password) VALUES (?, ?, ?)'

            const [result] = await db.promise().query(sql, [
                ...Object.values(UserData),
                await bcrypt.hash(password, 10)
            ])

            res.status(201).json({
                status: "201",
                message: "Data Berhasil Masuk",
                data: {
                    id: result.insertId,
                    ...data
                }
            })

        } catch (error) {
            console.log(error)

            res.status(500).json({
                status: "500",
                message: "Terjadi kesalahan pada server"
            })
        }
    }


    static async UpdateUser(req, res) {
        try {
            const id = req.params.id
            const data = req.body
            const { password, ...UserData } = data
            // Validasi
            if (!data.name || !data.email) {
                return res.status(400).json({
                    status: "400",
                    message: "Name dan email wajib diisi"
                })
            }

            const [validate] = await db.promise().query(
                'SELECT email FROM user WHERE email = ? AND id != ?',
                [data.email, id]
            )

            if (validate.length > 0) {
                return res.status(400).json({
                    status: "400",
                    message: "Email sudah terpakai, ganti email baru"
                })
            }

            const sql = 'UPDATE user SET name = ?, email = ?, password = ? WHERE id = ?'

            const [result] = await db.promise().query(sql, [
                ...Object.values(UserData),
                await bcrypt.hash(password, 10),
                id
            ])

            if (result.affectedRows === 0) {
                return res.status(404).json({
                    status: "404",
                    message: "User tidak ditemukan"
                })
            }

            res.json({
                status: "200",
                message: "Data Berhasil Diubah",
                data: {
                    id: id,
                    ...data
                }
            })

        } catch (error) {
            console.log(error)

            res.status(500).json({
                status: "500",
                message: "Terjadi kesalahan pada server"
            })
        }
    }


    static async DeleteUser(req, res) {
        try {
            const id = req.params.id

            const sql = 'DELETE FROM user WHERE id = ?'

            const [result] = await db.promise().query(sql, [id])

            if (result.affectedRows === 0) {
                return res.status(404).json({
                    status: "404",
                    message: "User tidak ditemukan"
                })
            }

            res.json({
                status: "200",
                message: "Data Berhasil Dihapus"
            })

        } catch (error) {
            console.log(error)

            res.status(500).json({
                status: "500",
                message: "Terjadi kesalahan pada server"
            })
        }
    }
}

module.exports = UserController
