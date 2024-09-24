<?php
session_start();

// ตรวจสอบว่ามีการส่งข้อมูลมาหรือไม่
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // ค่าที่ส่งมาจากฟอร์ม
    $username = $_POST['username'];
    $password = $_POST['password'];

    // ตรวจสอบ username และ password ในฐานข้อมูล (สมมติว่ามีการเชื่อมต่อกับฐานข้อมูลแล้ว)
    // เช่น ใช้ SQL query เพื่อตรวจสอบ

    // สมมติว่าตรวจสอบเรียบร้อยแล้ว ให้สร้าง session และ redirect ไปยังหน้า welcome.php
    $_SESSION['username'] = $username;
    header("Location: welcome.php");
    exit();
}
?>
