using Baker_API.Domains;
using Baker_API.Interfaces;
using Baker_API.Views;
using static System.Net.Mime.MediaTypeNames;

namespace Baker_API.Services
{
    public class Produtos : IProdutos
    {

        public void Insert(ProdutoView produto)
        {
            try
            {
                Repository.ProdutoRepository rep = new Repository.ProdutoRepository();
                rep.Insert(Converter(produto));
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void Update(ProdutoView produto)
        {
            try
            {
                Repository.ProdutoRepository rep = new Repository.ProdutoRepository();
                rep.Update(Converter(produto));
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void Delete(int CD_PRODUTO)
        {
            try
            {
                Repository.ProdutoRepository rep = new Repository.ProdutoRepository();
                rep.Delete(CD_PRODUTO);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<ProdutoView> List(Guid CD_USUARIO)
        {
            try
            {
                Repository.ProdutoRepository rep = new Repository.ProdutoRepository();

                List<ProdutoModel> lista = rep.List(CD_USUARIO);
                List<ProdutoView> ListaProdutos = new List<ProdutoView>();

                foreach (ProdutoModel produtoModel in lista)
                {
                    ProdutoView model = new ProdutoView();
                    model = Converter(produtoModel);

                    ListaProdutos.Add(model);
                }

                if (ListaProdutos.Count() == 0)
                {
                    return null;
                }

                return ListaProdutos;
            }
            catch (Exception)
            {
                throw;
            }
        }

        private ProdutoModel Converter(ProdutoView produto)
        {
            ProdutoModel obj = new ProdutoModel();

            byte[] VB_IMAGEM = ConvertToByte(produto.FF_IMAGEM);

            obj.CD_PRODUTO = produto.CD_PRODUTO;
            obj.DS_PRODUTO = produto.DS_PRODUTO;
            obj.NM_PRODUTO = produto.NM_PRODUTO;
            obj.VL_PRECO = produto.VL_PRECO;
            obj.CD_USUARIO = produto.CD_USUARIO;
            obj.VB_IMAGEM = VB_IMAGEM;
            obj.LS_ALIMENTOS_RESTRITOS = produto.LS_ALIMENTOS_RESTRITOS;

            return obj;
        }

        private ProdutoView Converter(ProdutoModel produto)
        {
            ProdutoView obj = new ProdutoView();

            obj.CD_PRODUTO = produto.CD_PRODUTO;
            obj.DS_PRODUTO = produto.DS_PRODUTO;
            obj.NM_PRODUTO = produto.NM_PRODUTO;
            obj.VL_PRECO = produto.VL_PRECO;
            obj.CD_USUARIO = produto.CD_USUARIO;
            obj.FF_IMAGEM = produto.FF_IMAGEM;
            obj.VB_IMAGEM = produto.VB_IMAGEM;
            obj.LS_ALIMENTOS_RESTRITOS = produto.LS_ALIMENTOS_RESTRITOS;

            return obj;
        }

        private byte[] ConvertToByte(IFormFile imagem)
        {
            byte[] imagemBytes;
            using (var stream = imagem.OpenReadStream())
            {
                using (var memoryStream = new System.IO.MemoryStream())
                {
                    stream.CopyTo(memoryStream);
                    imagemBytes = memoryStream.ToArray();
                }
            }

            return imagemBytes;
        }
    }
}
