using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using System.Collections.Generic;
using System.Linq;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

// In-memory database
var players = new List<Player>();

// Add a new player
app.MapPost("/players", (Player player) => {
    players.Add(player);
    return Results.Created($"/players/{player.Id}", player);
});

// Get all players
app.MapGet("/players", () => Results.Ok(players));

// Get a specific player by ID
app.MapGet("/players/{id}", (int id) => {
    var player = players.FirstOrDefault(p => p.Id == id);
    return player is not null ? Results.Ok(player) : Results.NotFound();
});

// Update player score
app.MapPut("/players/{id}/score", (int id, int score) => {
    var player = players.FirstOrDefault(p => p.Id == id);
    if (player is not null) {
        player.Score = score;
        return Results.Ok(player);
    }
    return Results.NotFound();
});

// Run the app
app.Run();

class Player
{
    public int Id { get; set; }
    public string Name { get; set; }

    public int Score { get; set; }

}

