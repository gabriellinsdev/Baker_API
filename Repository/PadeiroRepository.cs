using Baker_API.Domains;
using Baker_API.Models;
using System.Xml.Linq;

namespace Baker_API.Repository
{
    public class PadeiroRepository
    {

        const string dbName = "DB_BAKER";

        public List<PadeiroModel> List(string NM_CIDADE)
        {
            Helper helper = new Helper();
            return helper.ExecuteList<PadeiroModel>(dbName, "dbo.spLSTLocalizacaoPadeiros", new
            {
                NM_CIDADE
            });

        }
    }
}
