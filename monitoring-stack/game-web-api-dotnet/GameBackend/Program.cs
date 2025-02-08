using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using System.Collections.Generic;
using System.Linq;
using Prometheus;
using Microsoft.Extensions.Logging;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add logging
Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Information()
    .WriteTo.Console() // Standard output (visible in `kubectl logs`)
    .CreateLogger();

// for LOKI, use .WriteTo.GrafanaLoki("http://loki-service:3100") 

builder.Host.UseSerilog();



var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

// Create an ILogger instance
var logger = app.Services.GetRequiredService<ILogger<Program>>();

// Middleware for logging all incoming requests
app.Use(async (context, next) =>
{
    logger.LogInformation("Received request: {Method} {Path} from {IP}",
        context.Request.Method, context.Request.Path, context.Connection.RemoteIpAddress);
    
    await next();
});


// In-memory database
var players = new List<Player>();

// Add a new player
app.MapPost("/players", (Player player) => {
    players.Add(player);
    return Results.Created($"/players/{player.Id}", player);
});


// Sample metric for player request total
// Creating a counter metric
var playerRequests = Metrics.CreateCounter("player_requests_total", "Total number of requests to the players endpoint");


//Fake Error Endpoint to simulate an error
app.MapGet("/error", () =>
{
    logger.LogError("An error occurred in the /error endpoint."); // Simulate error logging
    return Results.Problem("Simulated error");
});

// Get all players
app.MapGet("/players", () =>
{
    playerRequests.Inc();  // Increment metric count
    return Results.Ok(players);
});

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

// Expose metrics so that prometheus can scrape them
app.UseMetricServer();
app.UseHttpMetrics();

// Run the app
app.Run();

class Player
{
    public int Id { get; set; }
    public string Name { get; set; }

    public int Score { get; set; }

}

