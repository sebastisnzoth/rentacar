import { Car, MapPin, ShieldCheck, WalletCards } from 'lucide-react';

const cars = [
  { id: 1, name: 'Volkswagen T-Cross', city: 'Florianópolis', price: 189, year: 2024 },
  { id: 2, name: 'Chevrolet Onix', city: 'São José', price: 139, year: 2023 },
  { id: 3, name: 'Jeep Renegade', city: 'Florianópolis', price: 219, year: 2024 },
];

export default function Home() {
  return (
    <main>
      <section className="hero">
        <nav className="nav container">
          <div className="brand"><Car size={28} /> RentMyCar</div>
          <div className="navActions"><button className="ghost">Entrar</button><button className="dark">Anunciar meu carro</button></div>
        </nav>
        <div className="container heroContent">
          <span className="eyebrow">ALUGUEL DE CARROS ENTRE PESSOAS</span>
          <h1>Seu próximo carro pode estar a poucos metros de você.</h1>
          <p>Reserve carros de pessoas reais ou ganhe dinheiro alugando o seu quando não estiver usando.</p>
          <div className="searchCard">
            <label><span>Onde?</span><div><MapPin size={18}/> Florianópolis, SC</div></label>
            <label><span>Retirada</span><div>27 set · 10:00</div></label>
            <label><span>Devolução</span><div>29 set · 10:00</div></label>
            <button>Buscar carros</button>
          </div>
        </div>
      </section>

      <section className="container section">
        <div className="sectionHead"><div><span className="eyebrow">PERTO DE VOCÊ</span><h2>Carros disponíveis</h2></div><button className="ghost">Ver todos</button></div>
        <div className="grid">
          {cars.map((car) => (
            <article className="card" key={car.id}>
              <div className="carImage"><Car size={64}/><span className="badge">Disponível</span></div>
              <div className="cardBody"><div className="titleRow"><div><h3>{car.name}</h3><p>{car.year} · Automático</p></div><strong>R$ {car.price}<small>/dia</small></strong></div><div className="location"><MapPin size={15}/>{car.city}</div></div>
            </article>
          ))}
        </div>
      </section>

      <section className="featureBand"><div className="container features">
        <div><ShieldCheck/><h3>Identidade verificada</h3><p>Proprietários e motoristas passam por validação antes de alugar.</p></div>
        <div><WalletCards/><h3>Pagamento seguro</h3><p>A plataforma registra pagamentos, caução e repasses.</p></div>
        <div><Car/><h3>Check-in com evidências</h3><p>Fotos, quilometragem, combustível e condição do veículo antes e depois.</p></div>
      </div></section>
    </main>
  );
}
