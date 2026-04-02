<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

$name    = htmlspecialchars(trim($_POST['name'] ?? ''));
$company = htmlspecialchars(trim($_POST['company'] ?? ''));
$email   = htmlspecialchars(trim($_POST['email'] ?? ''));
$phone   = htmlspecialchars(trim($_POST['phone'] ?? ''));
$message = htmlspecialchars(trim($_POST['message'] ?? ''));

if (!$name || !$email || !$message) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing required fields']);
    exit;
}

$body = "Name: $name\n";
if ($company) $body .= "Company: $company\n";
$body .= "Email: $email\n";
if ($phone) $body .= "Phone: $phone\n";
$body .= "\nMessage:\n$message";

$payload = json_encode([
    'from'     => 'contact@plusopto.co.uk',
    'to'       => ['sales@plusopto.co.uk'],
    'subject'  => "Website enquiry from $name",
    'text'     => $body,
    'reply_to' => $email
]);

$ch = curl_init('https://api.resend.com/emails');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Authorization: Bearer re_THow3y9a_5sPdma41UND4wffZkZnx9dXX',
    'Content-Type: application/json'
]);
$response = curl_exec($ch);
$status   = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($status === 200 || $status === 201) {
    echo json_encode(['success' => true]);
} else {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to send email', 'detail' => $response]);
}
