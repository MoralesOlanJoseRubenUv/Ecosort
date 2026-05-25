using Godot;
using System;
using Godot.Collections;

public static class PlayerDataManager
{
    public static string CurrentUsername = "";
    public static int TotalScore = 0;
    public static int CurrentLevel = 1;

    public static float FallingSpeed = 1.0f;
    public static int MaxLives = 3;
    public static bool IncludeSecondUse = true;

    // Función para guardar los datos en el archivo JSON
    public static void SaveProgress(string password)
    {
        if (string.IsNullOrEmpty(CurrentUsername)) return;

        var data = new Dictionary
        {
            { "username", CurrentUsername },
            { "password", password }, // Guardamos la contraseña para el login
            { "total_score", TotalScore },
            { "current_level", CurrentLevel }
        };

        string jsonString = Json.Stringify(data);
        using var file = FileAccess.Open($"user://{CurrentUsername}_save.json", FileAccess.ModeFlags.Write);
        if (file != null)
        {
            file.StoreString(jsonString);
        }
    }
}