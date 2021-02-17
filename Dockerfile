#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["SampleCICD.Web/SampleCICD.Web.csproj", "SampleCICD.Web/"]
RUN dotnet restore "SampleCICD.Web/SampleCICD.Web.csproj"
COPY . .
WORKDIR "/src/SampleCICD.Web"
RUN dotnet build "SampleCICD.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SampleCICD.Web.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SampleCICD.Web.dll"]