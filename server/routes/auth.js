import express from 'express';
import User from '../models/user.js'; // Correct the path if needed
import jwt from 'jsonwebtoken';
import auth from '../middlewares/auth.js';
const authRouter = express.Router();

authRouter.post('/api/signup', async (req, res) => {
    try {
        const { name, email, profilePic } = req.body;

        // console.log("Request Body:", req.body); // Log the incoming request body

        // Ensure that email is present
        if (!email) {
            return res.status(400).json({ message: "Email is required" });
        }

        let user = await User.findOne({ email: email });

        if (!user) {
            user = new User({
                email: email, // Ensure this is the correct key
                name: name,
                profilePic: profilePic,
            });

            user = await user.save();
            console.log('User Registered Successfully');
        }
        const token = jwt.sign({id: user._id}, "passwordKey");
        

        console.log('api called succesfully returning user');

        res.json({ user,token });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ message: "Internal server error" });
    }
});
authRouter.get('/api/v1',(req,res)=>{
    res.send('hello');
})
authRouter.get('/',auth,async(req,res)=>{
    const user = await User.findById(req.user);
    res.json({user,token :req.token })
})

export default authRouter;
