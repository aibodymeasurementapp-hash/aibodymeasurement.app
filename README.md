ai_body_measure_app
This project is a starting point for a Flutter application. It is being developed as a Final Year Design Project (FYP) by the following team members from the University of the Punjab, Gujranwala Campus:

Muhammad Imran (BCS 22045) 

Hassan Abdullah (BCS 22014) 

Muhammad Ertaza (BCS 22044)

Dawood Rasheed (BCS 22046) 

Project Overview
The AI Based Body Measurement App is designed to extract accurate human body measurements (such as chest, waist, hip, and arm length) directly from images using AI-based pose estimation models like ML Kit, MoveNet, or PoseNet. The primary goal is to provide a privacy-preserving and efficient solution where all image processing is performed on-device.

The application aims to:


Extract Body Measurements: Use AI to detect body keypoints and calculate precise measurements.


Provide Dress Recommendations: Offer personalized size suggestions and dress designs based on the user's latest measurements to reduce online shopping returns.


Ensure Privacy: Process all sensitive data locally without sending images to external servers.


Secure Data Storage: Integrate Firebase for secure user authentication and historical measurement storage.

Team Roles & Responsibilities
Based on the project's System Requirements Specification (SRS), the team members fulfill various technical roles necessary for the development of this AI-driven platform:


System Developers: Responsible for implementing the core application logic, integrating the AI pose estimation models (ML Kit/MoveNet), and ensuring seamless interaction between the Flutter frontend and the Firebase backend.


QA Specialists: Focused on testing the system to validate the accuracy of the body measurements and ensuring the performance meets the required 90% accuracy threshold.


Security Experts: tasked with implementing end-to-end encryption for user data and ensuring that all sensitive images are processed strictly on-device.


Administrators: Manage the backend infrastructure, including the Firebase Firestore database and the dress catalog updates.

Frontend Development Status
The project is currently in its initial stages, focusing on the frontend development. The interface follows Google Material Design guidelines and includes several key functional screens:


Home Dashboard: The main entry point with options to capture images, view history, or browse recommendations.


Guidance & Capture: Screens that provide instructions for correct posture and allow users to capture or upload images via the device camera or gallery.


Results Display: A visual interface showing detected keypoints and the calculated measurement values.


Personalized Catalog: A view dedicated to recommended dresses and sizes matched to the user's profile.
