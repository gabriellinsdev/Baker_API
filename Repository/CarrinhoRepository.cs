using Baker_API.Domains;
using Baker_API.Models;

namespace Baker_API.Repository
{
    public class CarrinhoRepository
    {
        const string dbName = "DB_BAKER";

        public void Save(CarrinhoModel carrinho)
        {
            Helper helper = new Helper();
            helper.ExecuteScalar(dbName, "dbo.spINSCarrinho", new
            {
                carrinho.CD_PRODUTO,
                carrinho.CD_USUARIO
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
