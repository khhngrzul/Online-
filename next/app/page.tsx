"use client";
import {useState} from "react";
const products = [
  {
    id: 1,
    name: "Программчлалын сурах бичиг",
    category: "Ном",
    price: "15,000₮",
    condition: "Сайн",
    emoji: "📚",
    color: "#e7e9ff",
  },
  {
    id: 2,
    name: "Оюутны үүргэвч",
    category: "Хувцас, хэрэглэл",
    price: "25,000₮",
    condition: "Сайн",
    emoji: "🎒",
    color: "#fce8d9",
  },
  {
    id: 3,
    name: "Утасгүй чихэвч",
    category: "Электроник",
    price: "35,000₮",
    condition: "Маш сайн",
    emoji: "🎧",
    color: "#e0f2e9",
  },
  {
    id: 4,
    name: "Ширээний гэрэл",
    category: "Гэр ахуй",
    price: "18,000₮",
    condition: "Сайн",
    emoji: "💡",
    color: "#fff0bf",
  },
  {
    id: 5,
    name: "Математикийн ном",
    category: "Ном",
    price: "10,000₮",
    condition: "Хэрэглэсэн",
    emoji: "📖",
    color: "#f5e3f4",
  },
  {
    id: 6,
    name: "Спорт пүүз",
    category: "Хувцас, хэрэглэл",
    price: "45,000₮",
    condition: "Сайн",
    emoji: "👟",
    color: "#dcecff",
  },
];

const categories = [
  "Бүгд",
  "Ном",
  "Хувцас, хэрэглэл",
  "Электроник",
  "Гэр ахуй",
];

export default function Home() {
  return (
    <main>
      <header className="navbar">
        <a href="/" className="logo">
          <span className="logo-icon">↗</span>
          Оюутан<span className="logo-accent">Зах</span>
        </a>

        <nav className="nav-links">
          <a href="#products">Зарууд</a>
          <a href="#categories">Ангилал</a>
          <a href="#about">Бидний тухай</a>
        </nav>

        <a href="#sell" className="sell-button">
          + Зар нэмэх
        </a>
      </header>

      <section className="hero">
        <div className="hero-content">
          <span className="eyebrow">
              ОЮУТНУУДЫН ХУДАЛДАА, СОЛИЛЦОО
          </span>
          <h1>
            Хэрэглэсэн зүйлд
            <br />
            <span>шинэ боломж.</span>
          </h1>
          <p>
            Хэрэглэхээ больсон зүйлээ бусад оюутантай
            хуваалц. Хэрэгтэй зүйлээ хямд олж аваарай.
          </p>

          <a href="#products" className="hero-button">
            Зар үзэх <span>→</span>
          </a>

          <div className="hero-note">
            ♻️ Дахин ашиглая, хамтдаа хэмнэе.
          </div>
        </div>

        <div className="hero-art">
          <div className="art-circle">
            <span className="art-book">📚</span>
            <span className="art-bag">🎒</span>
            <span className="art-headphone">🎧</span>
            <span className="art-spark">✳</span>
            <div className="art-label">
              <span>BUY LESS</span>
              <strong>Share more.</strong>
            </div>
          </div>
        </div>
      </section>

      <section className="search-area">
        <div>
          <h2>Юу хайж байна вэ?</h2>
          <p>Оюутнуудад хэрэгтэй зүйлс нэг дор.</p>
        </div>
        <form action="#products" className="search-box">
          <span>⌕</span>
          <input
            name="q"
            placeholder="Ном, цүнх, чихэвч хайх..."
            aria-label="Зар хайх"
          />
          <button type="submit">Хайх</button>
        </form>
      </section>

      <section id="categories" className="category-section">
        <div className="section-heading">
          <div>
            <span className="eyebrow">АНГИЛЛААР ҮЗЭХ</span>
            <h2>Юу хэрэгтэй байна?</h2>
          </div>
        </div>
        <div className="category-list">
          {categories.map((category, index) => (
            <a
              key={category}
              href="#products"
              className={`category-chip ${index === 0 ? "active" : ""}`}
            >
              {["✳", "📚", "👕", "🎧", "🏠"][index]}
              {" "}{category}
            </a>
          ))}
        </div>
      </section>

      <section id="products" className="products-section">
        <div className="section-heading">
          <div>
            <span className="eyebrow">ШИНЭ ЗАРУУД</span>
            <h2>Оюутнуудын зар</h2>
          </div>
          <span className="product-count">
            {products.length} жишээ зар
          </span>
        </div>

        <div className="product-grid">
          {products.map((product) => (
            <article className="product-card" key={product.id}>
              <div
                className="product-image"
                style={{ backgroundColor: product.color }}
              >
                <span className="product-emoji">
                  {product.emoji}
                </span>
                <span className="condition">
                  {product.condition}
                </span>
                  <span className="heart" aria-label="Хадгалах">
  ♡
                  </span>
              </div>
              <div className="product-info">
                <span className="product-category">
                  {product.category}
                </span>
                <h3>{product.name}</h3>
                <div className="product-bottom">
                  <strong>{product.price}</strong>
                  <span>↗ Дэлгэрэнгүй</span>
                </div>
              </div>
            </article>
          ))}
        </div>
      </section>

      <section id="sell" className="sell-banner">
        <div>
          <span className="eyebrow">ӨӨРИЙН ЗАРАА НЭМЭЭРЭЙ</span>
          <h2>Хэрэглэхгүй зүйл байна уу?</h2>
          <p>
            Өөр нэг оюутанд хэрэгтэй байж магадгүй.
            Өөрийн зараа удахгүй энд нийтлээрэй.
          </p>
        </div>
        <a href="mailto:hello@example.com" className="hero-button">
          Зарын талаар холбогдох →
        </a>
      </section>

      <footer id="about" className="footer">
        <a href="/" className="logo">
          <span className="logo-icon">↗</span>
          Оюутан<span className="logo-accent">Зах</span>
        </a>
        <p>Оюутнаас оюутанд. ♻️</p>
        <span>© 2026 ОюутанЗах · Сургалтын загвар</span>
      </footer>
    </main>
  );
}
