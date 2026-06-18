FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY EduWeb.sln .
COPY NuGet.config .
COPY EduWeb.Api/EduWeb.Api.csproj EduWeb.Api/
RUN dotnet restore EduWeb.Api/EduWeb.Api.csproj

COPY EduWeb.Api/ EduWeb.Api/
WORKDIR /src/EduWeb.Api
RUN dotnet publish -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_ENVIRONMENT=Production
EXPOSE 8080

ENTRYPOINT ["dotnet", "EduWeb.Api.dll"]
