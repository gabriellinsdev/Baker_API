using Baker_API.Domains;
using Baker_API.Services;
using Baker_API.Views;
using Microsoft.AspNetCore.Mvc;

namespace Baker_API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProdutosController : ControllerBase
    {

        [HttpPut("Insert")]
        public void Insert(ProdutoView produto)
        {
            Produtos prod = new Produtos();
            prod.Insert(produto);
        }

        [HttpPut("Update")]
        public void Update(ProdutoView produto)
        {
            Produtos prod = new Produtos();
            prod.Update(produto);
        }

        [HttpPut("Delete")]
        public void Delete(int idProduto)
        {
            Produtos prod = new Produtos();
            prod.Delete(idProduto);
        }

        [HttpGet("List")]
        public void List(Guid usuario)
        {
            Produtos prod = new Produtos();
            var ListaProduto = prod.List(usuario);
        }

    }
}
