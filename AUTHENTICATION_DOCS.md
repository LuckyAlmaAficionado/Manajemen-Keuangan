# Dokumentasi Authentication System

## Overview

Sistem authentication yang telah diimplementasi terdiri dari komponen-komponen berikut:

## Komponen Utama

### 1. AuthConstants (`lib/constants/auth_constants.dart`)

Komponen untuk menyimpan dan mengelola token serta data user menggunakan SharedPreferences.

**Fitur:**

- `saveToken(String token)` - Menyimpan bearer token
- `getToken()` - Mengambil bearer token
- `saveUserData()` - Menyimpan data user (ID, nama, email)
- `getUserData()` - Mengambil data user
- `isLoggedIn()` - Mengecek status login
- `clearAuthData()` - Logout (hapus semua data auth)

### 2. AuthService (`lib/services/auth_service.dart`)

Service untuk simulasi API login dan register.

**Fitur:**

- `login(String email, String password)` - Simulasi login API
- `register(String name, String email, String password)` - Simulasi register API
- `logout()` - Logout user

**Note:** Saat ini menggunakan fake token untuk simulasi. Dalam implementasi production, ganti dengan real API calls.

### 3. Login Screen (`lib/screens/login_screen.dart`)

Tampilan login yang elegan dengan desain gradient dan form validation.

**Fitur:**

- Form email dan password dengan validasi
- Loading state saat login
- Error handling dengan snackbar
- Link ke halaman register
- Password visibility toggle

### 4. Register Screen (`lib/screens/register_screen.dart`)

Tampilan register yang elegan dengan desain yang konsisten dengan login.

**Fitur:**

- Form nama, email, password, dan konfirmasi password
- Validasi form yang lengkap
- Loading state saat register
- Error handling dengan snackbar
- Link ke halaman login
- Password visibility toggle

### 5. Splash Screen (`lib/screens/splash_screen.dart`)

Splash screen yang telah dimodifikasi untuk mengecek status authentication.

**Logic:**

- Menampilkan splash selama 3 detik
- Mengecek `AuthConstants.isLoggedIn()`
- Jika sudah login: navigate ke home screen
- Jika belum login: navigate ke login screen

### 6. UserInfoWidget (`lib/widgets/user_info_widget.dart`)

Widget yang menampilkan informasi user dan tombol logout.

**Fitur:**

- Menampilkan avatar user (initial dari nama)
- Menampilkan nama dan email user
- Tombol logout dengan konfirmasi dialog
- Auto-navigate ke login setelah logout

### 7. Profile Screen (`lib/screens/profile_screen.dart`)

Profile screen yang telah diupdate untuk menggunakan UserInfoWidget.

**Fitur:**

- Menampilkan informasi user
- Menu-menu profile lainnya
- Integrated logout functionality

## Routes yang Ditambahkan

Di `lib/routes/app_routes.dart`:

```dart
static const String login = '/login';
static const String register = '/register';
```

Di `lib/routes/app_router.dart`:

- Route untuk LoginScreen
- Route untuk RegisterScreen

## Flow Authentication

1. **App Start** → Splash Screen
2. **Splash Screen** → Cek `isLoggedIn()`
   - Jika `true` → Home Screen
   - Jika `false` → Login Screen
3. **Login Screen** → Input credentials → AuthService.login()
   - Success → Save token → Home Screen
   - Failed → Show error message
4. **Register Screen** → Input data → AuthService.register()
   - Success → Save token → Home Screen
   - Failed → Show error message
5. **Profile Screen** → Logout → Clear auth data → Login Screen

## Desain UI

**Color Scheme:**

- Primary: Blue (#1976D2)
- Background: Linear gradient blue
- Cards: White dengan shadow
- Accent: Blue shades

**Components:**

- Rounded corners (12px)
- Consistent padding (16-24px)
- Material 3 design
- Elegant gradient backgrounds
- Clean typography

## Testing

Untuk testing login/register, gunakan:

- **Email:** Any valid email format (example@test.com)
- **Password:** Minimal 6 karakter

Sistem akan menerima kredensial apapun selama format valid dan field tidak kosong.

## Next Steps

Untuk production:

1. Ganti AuthService dengan real API calls
2. Implementasi proper error handling
3. Tambahkan forgot password functionality
4. Implementasi refresh token mechanism
5. Tambahkan biometric authentication (optional)
