# 🐾 Pet Care

A **mobile application** built using **Flutter**, **Firebase**, and **Machine Learning (Flask API)** to help pet owners manage their pets, post for adoption, and find lost pets using **AI-based image recognition** and **QR codes**.

---

## 🚀 Overview

**Pet Care** is a comprehensive mobile solution designed to improve the welfare of pets and assist pet owners in managing, finding, and adopting animals.  
The app allows users to:
- Register and manage pets.
- Post about **lost, found, or adoptable pets**.
- Generate and scan **unique QR codes** for pet identification.
- Use **AI-powered image recognition** to match lost pets with found ones.
- Access information about **shelters**, **pharmacies**, and **pet services**.

This project was developed as a **graduation project (Cairo University, Faculty of Computers and AI)**.

---

## 🧠 Core Features

### 🐶 Pet Management
- Add, edit, or delete pet profiles.
- Store essential pet information (age, type, gender, birth date, health notes).

### 📸 AI-Powered Lost & Found
- Upload an image of a lost pet to search for matches using **deep learning**.
- The system compares uploaded photos with found pets to identify possible matches.

### 🔍 QR Code Identification
- Each pet has a **unique QR code**.
- Scanning the QR code reveals the pet’s info and helps connect with the owner.

### 💬 Community Interaction
- Share posts about missing, found, or adoptable pets.
- Engage with other users to support pet welfare.

### 🏥 Pet Services
- Browse nearby shelters, pharmacies, and other pet-related services.

---

## 🧩 Tech Stack

| Layer | Technology |
|-------|-------------|
| **Frontend** | Flutter, Dart |
| **Backend** | Flask (Python) |
| **Database** | Firebase (Firestore, Authentication, Storage) |
| **Machine Learning** | TensorFlow (EfficientNet-B4 with Transfer Learning) |
| **Deployment** | Ngrok for API exposure |
| **Project Management** | GitHub, Trello |

---

## 🧠 Machine Learning Model

- Implemented using **EfficientNet-B4** from TensorFlow Hub.
- Fine-tuned on a **custom pet dataset (dogs and cats)** from Kaggle.
- Achieved **~97% accuracy**.
- Used **feature vector extraction** for image similarity matching.

---

## ⚙️ System Architecture

**Components:**
- **Flutter App:** User interface for all core functionalities.
- **Firebase Cloud:** Stores user, pet, and post data.
- **Flask API:** Connects the app with the ML model for image matching.
- **QR Scanner:** Enables pet identification.

