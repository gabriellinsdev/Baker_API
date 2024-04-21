﻿using Baker_API.Domains;
using Baker_API.Models;

namespace Baker_API.Repository
{
    public class CarrinhoRepository
    {
        const string dbName = "DB_BAKER";

        public void Save(string xmlProdutos)
        {
            Helper helper = new Helper();
            helper.ExecuteScalar(dbName, "dbo.spINSCarrinho", new
            {
                PRODUTOS = xmlProdutos
            });
        }

        public List<CarrinhoModel> List(Guid CD_USUARIO)
        {
            Helper helper = new Helper();
            return helper.ExecuteList<CarrinhoModel>(dbName, "dbo.spLSTCarrinho", new
            {
                CD_USUARIO
            });

        }
    }
}
