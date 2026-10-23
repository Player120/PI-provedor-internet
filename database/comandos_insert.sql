insert into enderecos (estado, tipoEndereco, cep, logradouro, numero, bairro, cidade) values
('SP', 'Casa', '12345678', 'Rua Brasil', '1994', 'Jardim Paulista', 'São Paulo');

insert into contatos (telefonePrincipal, telefoneSecundario, email, aceitaNotificacao) values
('00123456789', '22987654321', 'rafael.zontarzb@gmail.com', "Sim");

insert into contratosassinaturas (dataAdesao, vencimentoFatura) values
('2020-11-10', '2027-12-30');

insert into clientes (
	nomeCompleto, tipoPessoa, cpfCnpj, rg, dataNascimento, dataCadastro, statusCliente, 
    enderecos_idendereco, contatos_idcontato, contratosassinaturas_idcontrato
) values
( 
	'Rafael Zonta', 'Física', '123.456.789-11', '123456789', '2007-12-12', '2020-11-09', 'Ativo',
	1, 1, 1
);

select * from enderecos;
select * from clientes;