using Newtonsoft.Json;

namespace TKTradersWebApp.SessionManagement
{
    public static class SessionHelper
    {
        public static void SetObjectAsJson(this ISession session, string key, object value)
        {
            session.SetString(key, JsonConvert.SerializeObject(value));
        }
        public static T GetObjectFromJson<T>(this ISession session, string key)
        {
            var value = session.GetString(key);
            return value == null ? default(T) : JsonConvert.DeserializeObject<T>(value);
        }
        public static void RemoveObjectFromJson(this ISession session, string key)
        {
            session.Remove(key);
        }
    }
}
