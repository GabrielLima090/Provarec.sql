create table investigadores (
id serial primary key,
nome varchar(100) not null,
cpf varchar(11) unique not null,
nivel_experiencia int default 0 check(nivel_experiencia >= 0)
);

create table carteiras (
id serial primary key,
investigador_id int references investigadores(id),
endereco_wallet varchar(100) unique not null,
rede_blockchain varchar(50) not null check(status in('Etherum', 'Bitcoin', 'Solana')),
saldo_usd decimal(10,2) not null check(saldo_usd > 0),
status varchar(50) default 'Ativa' check(status in('Em análise','Bloqueada', 'Pausada' , 'Ativa'))
);

create table corretoras(
id serial primary key,
nome_exchange varchar(50) not null,
cnpj varchar(14) unique not null,
email_suporte varchar(100) unique not null
);

create table criptomoedas(
id serial primary key,
corretora_id int references corretoras(id),
nome_moeda varchar(50) not null check(nome_moeda in('Etherum', 'Bitcoin', 'Solana')),
preco_unitario_usd decimal(10,2) not null check(preco_unitario_usd > 0),
categoria varchar(50) default 'Layer 1' check(categoria in('Layer 1','DeFi', 'Memecoin' , 'Stablecoin'))
);

create table transacoes_cripto(
id serial primary key,
carteira_id int references carteiras(id),
criptomoeda_id int references criptomoedas(id),
quantidade decimal(10,2) not null check(quantidade > 0),
valor_pago decimal(10,2) not null check(valor_pago > 0),
data_transacao timestamp default current_timestamp
);

insert into investigadores (nome, cpf,nivel_experiencia) values
('Vinicius Neto', '95843256743', '2'),
('Marcos Luis', '36251783459', '1'),
('Patricia Castro', '35268945362', '3'),
('Bruna Santos', '94635218756', '2'),
('Daniel Wesley', '59321594504', '1');

insert into carteiras (investigador_id, endereco_wallet, rede_blockchain, saldo_usd, status) values
(1, 'Praça 15', 'Bitcoin', ' 50356', 'Em análise'),
(3, 'Avenida Paulista', 'Etherum', ' 409354', 'Pausada'),
(5, 'SC 401', 'Solana', ' 985387', 'Ativa'),
(2, 'Freeway', 'Bitcoin', ' 324512', 'Bloqueada'),
(4, 'Avenida Getúlio Vargas', 'Etherum', ' 735201', 'Em análise');

insert into corretoras (nome_exchange,cnpj,email_suporte) values
('Bradesco', '56321689043256' , 'bradesco@gmail.com'),
('Banco do Brasil', '56322689043256' , 'bancobrasil@gmail.com'),
('Inter', '52321989043236' , 'inter@gmail.com'),
('Master', '53321889043256' , 'master@gmail.com'),
('Btg', '26321649643256' , 'btg@gmail.com');


insert into criptomoedas (corretora_id,nome_moeda,preco_unitario_usd, categoria) values
(4 , 'Solana', 2658.43, 'DeFi'),
(2 , 'Bitcoin', 74396.13, 'Memecoin'),
(1 , 'Etherum', 39313.45, 'Stablecoin'),
(3 , 'Solana', 754908.29, 'DeFi'),
(5 , 'Bitcoin', 35257.83, 'Stablecoin');


insert into transacoes_cripto (carteira_id,criptomoeda_id,quantidade, valor_pago) values
(4 , 3, 25, 63612 ),
(1 , 2, 247, 7943033 ),
(2 , 2, 77, 43725092 ),
(3 , 1, 85, 784207 ),
(5 , 2, 982, 9696592 );

select * from carteiras where status = 'Ativa' or status = 'Em análise';

select c.nome_exchange,
sum(valor_pago) as valor_total_movimentado
from transacoes_cripto tc
join criptomoedas cm on tc.criptomoeda_id = cm.id
join corretoras c on cm.corretora_id = c.id
group by
c.nome_exchange

select ca.endereco_wallet,
cr.nome_moeda,
tc.quantidade,
tc.valor_pago,
tc.data_transacao
from
transacoes_cripto tc
join carteiras ca on tc.carteira_id = ca.id
join criptomoedas cr on tc.criptomoeda_id = cr.id
where tc.valor_pago > 500.00
order by
tc.valor_pago desc;

