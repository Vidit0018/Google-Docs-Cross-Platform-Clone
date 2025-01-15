import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true, // Ensure email is required
        unique: true,
    },
    name: {
        type: String,
        required: true,
    },
    profilePic: {
        type: String,
        required: false, // Optional
    },
});

const User = mongoose.model('User', userSchema);

export default User;
