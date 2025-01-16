import jwt from 'jsonwebtoken';
const auth = async(req,res,next)=>{
    try {
        // console.log('verifying token');
        const token = req.header("x-auth-token");
        if(!token){
            return res.status(401).json({msg:"No auth token ,access denied."});
        }

        const verified = jwt.verify(token,process.env.jwt_secret_key);

        if(!verified){
            return res.status(401).json({msg: "Token verification failed, authorization denied"});
        }

        req.user = verified.id;
        req.token = token ;
        next();
    } catch (error) {
       res.status(500).json({error : error.message}); 
    }
}

export default auth;
