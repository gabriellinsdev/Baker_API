using Baker_API.Domains;
using Baker_API.Models;
using Baker_API.Views;

namespace Baker_API.Repository
{
    public class CarrinhoRepository
    {
        const string dbName = "DB_BAKER";

        public void Save(CarrinhoView carrinho)
        {
            Helper helper = new Helper();
            helper.ExecuteScalar(dbName, "dbo.spINSCarrinho", new
            {
                carrinho.CD_USUARIO,
                carrinho.CD_PRODUTO,
                carrinho.QT_PRODUTO,
                carrinho.VL_PRECO 
            }) ;
        }

        public void Delete(Guid CD_USUARIO, int CD_PRODUTO)
        {
            Helper helper = new Helper();
            helper.ExecuteScalar(dbName, "dbo.spDELCarrinho", new
            {
                CD_USUARIO,
                CD_PRODUTO
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
