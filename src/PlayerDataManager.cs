using Godot;
using System;
using Godot.Collections;

public static class PlayerDataManager
{
    public static string CurrentUsername = "";
    public static string CurrentPassword = ""; // NUEVO: Guardamos la contraseña en memoria para auto-guardar
    public static int TotalScore = 0;
    public static int CurrentLevel = 1;
    
    // NUEVO: Esta es la variable que recordará cuántos niveles tiene desbloqueados
    public static int MaxUnlockedLevel = 1; 

    public static float FallingSpeed = 1.0f;
    public static int MaxLives = 3;
    public static bool IncludeSecondUse = true;

    // Función original que ya usabas (ideal para el Login/Registro)
    public static void SaveProgress(string password)
    {
        CurrentPassword = password; // Guardamos la contraseña en caché
        SaveProgress(); // Llamamos al método de abajo
    }

    // NUEVA FUNCIÓN: Permite guardar desde cualquier lado (como el WinMenu) sin pedir contraseña
    public static void SaveProgress()
    {
        if (string.IsNullOrEmpty(CurrentUsername)) return;

        var data = new Dictionary
        {
            { "username", CurrentUsername },
            { "password", CurrentPassword }, 
            { "total_score", TotalScore },
            { "current_level", CurrentLevel },
            { "max_unlocked_level", MaxUnlockedLevel } // ¡Guardamos el progreso de los botones aquí!
        };

        string jsonString = Json.Stringify(data);
        using var file = FileAccess.Open($"user://{CurrentUsername}_save.json", FileAccess.ModeFlags.Write);
        if (file != null)
        {
            file.StoreString(jsonString);
        }
    }
}