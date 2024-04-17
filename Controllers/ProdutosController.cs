using Baker_API.Domains;
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
            Insert(produto);
        }

        [HttpPut("Update")]
        public void Update(ProdutoView produto)
        {
            Update(produto);
        }

        [HttpGet("Delete")]
        public void Delete(Guid usuario, int produto)
        {
            Delete(usuario, produto);
        }

        [HttpGet("List")]
        public void List(Guid usuario)
        {
            List(usuario);
        }

    }
}
