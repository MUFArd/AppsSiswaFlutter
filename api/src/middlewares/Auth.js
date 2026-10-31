const jwt = require('jsonwebtoken')

const JWT_SECRET = '8fK2mP9xQ7vL4nR6sT1zW5yU3aB0cD'

const Auth = (req, res, next) => {
    try {
        const token = req.headers.authorization

        if (!token) {
            return res.status(401).json({
                status: 401,
                message: 'Token tidak ditemukan'
            })
        }

        const tokensplit = token.split('')[1]
        const data = jwt.verify(
            tokensplit,
            JWT_SECRET
        )

        req.user = data
        next()
    } catch (error) {
        return res.status(401).json({
            status: 401,
            message: 'Token tidak valid'
        })
    }
}

module.exports = Auth