# EpStore Features

EpStore is a Java-based JSP/Servlet e-commerce web application featuring two distinct user interfaces: the **Buyer Portal** and the **Seller Portal**.

---

## 1. Buyer Portal Features

- **Authentication & User Management**
  - Secure user registration and login (`AuthController.java`).
  - Personal profile settings management including update of shipping address and phone number (`UserSettingController.java`).

- **Product Browsing & Discovery**
  - Interactive homepage grid listing available products, excluding products owned by the logged-in buyer (`index.jsp`).
  - Search by keyword and category filters ("Semua", "Elektronik", "Fashion", "Makanan", "Kecantikan", "Lainnya").
  - Detailed product page showing product description, price, available stock, seller's shop name, and buyer reviews (`product.jsp`).

- **Shopping Cart & Stock Control**
  - Add products to cart, increment/decrement quantities with real-time stock ceiling validation (`CartController.java`).
  - Auto-hide cart badge in navbar when the cart is empty.

- **Checkout & Payment System**
  - Checkout summary showing order breakdown.
  - Integration with payment methods including Bank Transfer and E-Wallet (`PaymentController.java`).
  - Discount application using Kupon (Coupons).

- **Order Management & Transactions**
  - Order status tracking (e.g., Menunggu Pembayaran, Diproses, Dikirim, Selesai).
  - Complete order reception via the **"Terima Barang"** action.

- **Reviews & Ratings**
  - Rate products on a 1-5 star scale with optional comments (`BuyerReviewController.java`).
  - View seller replies inline under buyer reviews.

---

## 2. Seller Portal Features

- **Store Creation**
  - Create and register a custom store name linked to the user account.

- **Dashboard & Analytics**
  - Dashboard tracking the latest 5 orders and key store transactions (`SellerController.java`).

- **Product Inventory Management (CRUD)**
  - Add new products with image file upload support, category selection, and price/stok setup (`SellerProductController.java`).
  - Edit or delete existing inventory items.

- **Order Fulfillment**
  - View buyer orders and advance the fulfillment status (e.g., updating status to `Dikirim` when items are shipped).

- **Customer Interaction**
  - Review management dashboard displaying buyer ratings.
  - Interactive reply interface to post seller responses directly underneath customer comments (`ulasan.jsp`).
