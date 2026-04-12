<?php
/**
 * UPDATE BAKERY DATA SCRIPT
 * Run this once on your Hostinger server to:
 * 1. Remove testing categories/products
 * 2. Add "Bakery and Bread" category
 * 3. Add bakery products (prices ₹20-40)
 * 
 * Upload to /api/ folder, run in browser, then DELETE immediately.
 */

// ─── DB CONFIG ─────────────────────────────────────────────────────────────
$host     = "localhost";
$db_user  = "YOUR_DB_USER";  // ← Replace with your Hostinger DB username
$db_pass  = "YOUR_DB_PASS";  // ← Replace with your Hostinger DB password
$db_name  = "YOUR_DB_NAME";  // ← Replace with your Hostinger DB name

// ─── CONNECT ────────────────────────────────────────────────────────────────
$conn = mysqli_connect($host, $db_user, $db_pass, $db_name);

if (!$conn) {
    die("<h2 style='color:red'>❌ DB Connection failed: " . mysqli_connect_error() . "</h2>");
}

echo "<h2>🔄 Updating Database...</h2>";

// ─── STEP 1: REMOVE TESTING DATA ───────────────────────────────────────────
echo "<h3>Step 1: Removing testing data...</h3>";

// Find and delete testing categories
$testCats = mysqli_query($conn, "SELECT id FROM categories WHERE name LIKE '%test%' OR name LIKE '%testing%'");
while ($cat = mysqli_fetch_assoc($testCats)) {
    $catId = $cat['id'];
    // Delete products in this category first
    mysqli_query($conn, "DELETE FROM products WHERE category_id = $catId");
    // Delete the category
    mysqli_query($conn, "DELETE FROM categories WHERE id = $catId");
    echo "<p>🗑️ Deleted testing category ID: $catId and its products</p>";
}

// Delete any products with test/testing in name
$testProds = mysqli_query($conn, "SELECT id FROM products WHERE name LIKE '%test%' OR name LIKE '%testing%'");
while ($prod = mysqli_fetch_assoc($testProds)) {
    $prodId = $prod['id'];
    mysqli_query($conn, "DELETE FROM product_variants WHERE product_id = $prodId");
    mysqli_query($conn, "DELETE FROM products WHERE id = $prodId");
    echo "<p>🗑️ Deleted testing product ID: $prodId</p>";
}

echo "<p style='color:green'>✅ Testing data removed</p>";

// ─── STEP 2: ADD BAKERY CATEGORY ───────────────────────────────────────────
echo "<h3>Step 2: Adding Bakery & Bread category...</h3>";

$bakeryName = "Bakery and Bread";
$bakeryIcon = "bakery";

// Check if already exists
$check = mysqli_query($conn, "SELECT id FROM categories WHERE name = '$bakeryName'");
if (mysqli_num_rows($check) > 0) {
    $row = mysqli_fetch_assoc($check);
    $bakeryCatId = $row['id'];
    echo "<p style='color:orange'>⚠️ Category '$bakeryName' already exists (ID: $bakeryCatId)</p>";
} else {
    $insert = mysqli_query($conn, 
        "INSERT INTO categories (name, icon) VALUES ('$bakeryName', '$bakeryIcon')"
    );
    if ($insert) {
        $bakeryCatId = mysqli_insert_id($conn);
        echo "<p style='color:green'>✅ Created category '$bakeryName' (ID: $bakeryCatId)</p>";
    } else {
        die("<p style='color:red'>❌ Failed to create category: " . mysqli_error($conn) . "</p>");
    }
}

// ─── STEP 3: ADD BAKERY PRODUCTS ─────────────────────────────────────────
echo "<h3>Step 3: Adding bakery products...</h3>";

$bakeryProducts = [
    [
        "name" => "Fresh White Bread",
        "price" => 25,
        "image" => "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=300&fit=crop",
        "description" => "Soft and fluffy white bread, freshly baked daily"
    ],
    [
        "name" => "Brown Bread",
        "price" => 30,
        "image" => "https://images.unsplash.com/photo-1585476263060-b7a6f71b4197?w=400&h=300&fit=crop",
        "description" => "Healthy whole wheat brown bread"
    ],
    [
        "name" => "Milk Bread",
        "price" => 35,
        "image" => "https://images.unsplash.com/photo-1598373182133-52452f7691ef?w=400&h=300&fit=crop",
        "description" => "Rich and soft milk bread"
    ],
    [
        "name" => "Bun (4 Pcs)",
        "price" => 20,
        "image" => "https://images.unsplash.com/photo-1621236378699-8597fab6a5b1?w=400&h=300&fit=crop",
        "description" => "Soft dinner buns, pack of 4"
    ],
    [
        "name" => "Pav (Ladi Pav)",
        "price" => 25,
        "image" => "https://images.unsplash.com/photo-1601058268499-e5268c56b584?w=400&h=300&fit=crop",
        "description" => "Soft pav bread for vada pav, pack of 8"
    ],
    [
        "name" => "Croissant",
        "price" => 40,
        "image" => "https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400&h=300&fit=crop",
        "description" => "Buttery flaky croissant"
    ],
    [
        "name" => "Garlic Bread",
        "price" => 35,
        "image" => "https://images.unsplash.com/photo-1573140247632-f8fd74997d5c?w=400&h=300&fit=crop",
        "description" => "Garlic flavored bread with herbs"
    ],
    [
        "name" => "Bread Roll (2 Pcs)",
        "price" => 30,
        "image" => "https://images.unsplash.com/photo-1603569283847-aa295f0d016a?w=400&h=300&fit=crop",
        "description" => "Stuffed bread rolls, pack of 2"
    ],
    [
        "name" => "Khari Biscuit",
        "price" => 30,
        "image" => "https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400&h=300&fit=crop",
        "description" => "Crispy puff khari biscuits"
    ],
    [
        "name" => "Toast Rusk",
        "price" => 35,
        "image" => "https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400&h=300&fit=crop",
        "description" => "Crunchy toast rusk for tea time"
    ],
    [
        "name" => "Butterscotch Bread",
        "price" => 40,
        "image" => "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=300&fit=crop",
        "description" => "Sweet butterscotch flavored bread"
    ],
    [
        "name" => "Atta Bread",
        "price" => 35,
        "image" => "https://images.unsplash.com/photo-1585476263060-b7a6f71b4197?w=400&h=300&fit=crop",
        "description" => "Whole wheat atta bread, healthy choice"
    ]
];

$added = 0;
$skipped = 0;

foreach ($bakeryProducts as $product) {
    $name = mysqli_real_escape_string($conn, $product['name']);
    $price = $product['price'];
    $image = $product['image'];
    $desc = mysqli_real_escape_string($conn, $product['description']);
    
    // Check if product already exists
    $checkProd = mysqli_query($conn, "SELECT id FROM products WHERE name = '$name' AND category_id = $bakeryCatId");
    if (mysqli_num_rows($checkProd) > 0) {
        echo "<p style='color:orange'>⚠️ Product '$name' already exists</p>";
        $skipped++;
        continue;
    }
    
    // Insert product
    $insertProd = mysqli_query($conn,
        "INSERT INTO products (category_id, name, price, image, description) 
         VALUES ($bakeryCatId, '$name', $price, '$image', '$desc')"
    );
    
    if ($insertProd) {
        $productId = mysqli_insert_id($conn);
        
        // Add default variant
        $insertVariant = mysqli_query($conn,
            "INSERT INTO product_variants (product_id, size, price) 
             VALUES ($productId, 'Standard', $price)"
        );
        
        echo "<p style='color:green'>✅ Added: $name - ₹$price</p>";
        $added++;
    } else {
        echo "<p style='color:red'>❌ Failed to add: $name - " . mysqli_error($conn) . "</p>";
    }
}

// ─── SUMMARY ──────────────────────────────────────────────────────────────
echo "<hr><h2>📊 Summary</h2>";
echo "<p style='color:green'><b>✅ $added products added</b></p>";
echo "<p style='color:orange'><b>⚠️ $skipped products already existed</b></p>";
echo "<p><b>Category:</b> $bakeryName (ID: $bakeryCatId)</p>";

echo "<br><hr>";
echo "<p style='color:red'><b>⚠️ IMPORTANT: Delete this file from your server immediately after use!</b></p>";

mysqli_close($conn);
?>
