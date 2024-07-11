# AD-OTP
Google OTP Integration for Active Directory

Overview

Welcome to the Google OTP Integration for Active Directory repository. This project provides a seamless solution to enhance the security of your Active Directory environment by integrating Google OTP (One-Time Password) for two-factor authentication (2FA). This ensures that only authorized users with the correct OTP from Google Authenticator can access your Active Directory services.

Features

    Two-Factor Authentication (2FA): Adds an additional layer of security by requiring a Google OTP in addition to the standard Active Directory password.
    Easy Setup: Simple configuration and integration process with detailed documentation.
    Compatibility: Works with existing Active Directory setups without requiring significant changes.
    User Management: Allows administrators to manage OTP settings for individual users.
    Secure Authentication: Utilizes secure methods to generate and verify OTPs, ensuring robust protection against unauthorized access.

Prerequisites

Active Directory environment (Windows Server 2012 R2 or later)
Google Authenticator or any other TOTP-based application
Delphi IDE (RAD Studio 12 or later)
Administrative access to the Active Directory server

Installation

    Clone the Repository:

    sh

    git clone https://github.com/yourusername/google-otp-ad-delphi.git
    cd google-otp-ad-delphi

    Open in Delphi IDE:
        Open the Delphi project file (.dproj) in RAD Studio.

    Configure the Application:
        Update the configuration settings in the source code with your Active Directory settings and desired OTP settings.

    Build the Project:
        Compile the project in Delphi IDE to generate the executable.

    Run the Integration Application:
        Execute the compiled application to start the integration process.

Usage

    User Enrollment: Users need to enroll their accounts with a TOTP application like Google Authenticator.
    Authentication: Upon logging in, users will have to add OTP from their TOTP application in addition to their password.
	

Contributing

We welcome contributions from the community! Please read our CONTRIBUTING.md for guidelines on how to contribute to this project.
License

This project is licensed under the MIT License. See the LICENSE file for details.
Support

If you encounter any issues or have questions, please open an issue on GitHub or contact us at support@example.com.
Acknowledgements

    Inspired by various 2FA implementations and security best practices.
