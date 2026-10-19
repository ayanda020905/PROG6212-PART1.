using Microsoft.EntityFrameworkCore;
using RaceDay.API.Data;
using Microsoft.AspNetCore.Authentication.Cookies;
using System.Security.Claims;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<RaceDayContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection")));


// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddDistributedMemoryCache();

builder.Services.AddSession(options =>
{
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
    options.IdleTimeout = TimeSpan.FromMinutes(30);
});


builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.Cookie.HttpOnly = true;
        options.Cookie.IsEssential = true;
        options.Cookie.SameSite = SameSiteMode.Lax;
        options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
        options.ExpireTimeSpan = TimeSpan.FromMinutes(30);
        options.SlidingExpiration = true;

        options.Events.OnRedirectToLogin = context =>
        {
            context.Response.StatusCode = StatusCodes.Status401Unauthorized;
            return Task.CompletedTask;
        };

        options.Events.OnRedirectToAccessDenied = context =>
        {
            context.Response.StatusCode = StatusCodes.Status403Forbidden;
            return Task.CompletedTask;
        };
    });

builder.Services.AddAuthorization();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();


app.MapGet("/api/users", async (RaceDayContext db) =>
    await db.Users.Select(u => new
    {
        u.UserID,
        u.FirstName,
        u.LastName,
        u.Email,
        u.PhoneNumber,
        u.Role,
        u.DateRegistered
    }).ToListAsync())
    .RequireAuthorization();

app.MapGet("/api/events", async (RaceDayContext db) =>
    await db.Events.ToListAsync())
    .RequireAuthorization();

app.MapGet("/api/categories", async (RaceDayContext db) =>
    await db.Categories.ToListAsync())
    .RequireAuthorization();

app.MapGet("/api/enrolments", async (RaceDayContext db) =>
    await db.Enrolments.ToListAsync())
    .RequireAuthorization(policy => policy.RequireRole("Organiser"));

app.MapGet("/api/results", async (RaceDayContext db) =>
    await db.Results.ToListAsync())
    .RequireAuthorization(policy => policy.RequireRole("Organiser"));





// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseSession();

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

app.Run();
