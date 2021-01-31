# Dezvoltarea Aplicatiilor Web

* Link catre [Teams](https://teams.microsoft.com/l/team/19%3a0b65666abf16483dbbdfad42a4d4cd79%40thread.tacv2/conversations?groupId=4f94c14b-c6ec-45c4-bb32-fa4df8b75a88&tenantId=08a1a72f-fecd-4dae-8cec-471a2fb7c2f1).
* Link catre [Website](https://www.cezarabenegui.com/).
* Link catre [Rezolvari Lab](https://drive.google.com/drive/folders/12dB92SNl1ceahxZSGIKti3j64MBbctDh).

# Instructiuni Examen

## Entity -> Curs 4
Instalare Entity Framework:
Tools => NuGet package manager => Manager NuGet Packages for solution => Instalam EntityFramework pe proiect

Adaugare Baza De Date:
Click Dreapta pe App_Data => Add => New Item => Sql Server Database => Add

Adaugare Connection String:
Connection String se preia din Click Dreapta pe baza de date => Properties.
In Web.config se adauga
```XML
<connectionStrings>
<add name="DBConnectionString" providerName="System.Data.SqlClient"
connectionString="Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename='C:\...\App_Data\StudentDb.mdf';Integrated Security=True"/>
</connectionStrings>
```

Se adauga clasa intr-un model:
```C#
public class ApplicationDbContext : DbContext
 {
 public ApplicationDbContext() : base("DBConnectionString") { }
 public DbSet<Student> Students { get; set; }
 }
```

Se foloseste cu
```C#
var db = new ApplicationDbContext();
```




## Migratii -> Curs 5
Activare Migratii:
Package manager console =>
    enable-migrations -EnableAutomaticMigrations:$true
In Migrations/Configuration in functia Configurations se adauga
```C#
AutomaticMigrationDataLossAllowed = true;
ContextKey = "NumEProiect.ApplicationDbContext";
```
In contructorul lui ApplicationDbContext se adauga
```C#
Database.SetInitializer(new MigrateDatabaseToLatestVersion<ApplicationDbContext,
    Curs4Partea2.Migrations.Configuration>("DBConnectionString"));
```
Initializarea:
Package manager console => Add-Migration Initial
                        => Update-Database

Resetare baza de date: Package manager => Update-Database -Target:0





## Modele
```C#
namespace Laborator5App.Models
{
    public class Article
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage = "Titlul este obligatoriu")]
        [StringLength(100, ErrorMessage = "Titlul nu poate avea mai mult de 20 caractere")]
        public string Title { get; set; }

        [Required(ErrorMessage = "Continutul articolului este obligatoriu")]
        [DataType(DataType.MultilineText)]
        public string Content { get; set; }

        public DateTime Date { get; set; }

        [Required(ErrorMessage = "Categoria este obligatorie")]
        public int CategoryId { get; set; }

        public virtual Category Category { get; set; }
        public virtual ICollection<Comment> Comments { get; set; }

        public IEnumerable<SelectListItem> Categ { get; set; }
    }
}
```




## Controller
```C#
if (TempData.ContainsKey("ErrorMessage"))
    ViewBag.ErrorMessage = TempData["ErrorMessage"].ToString();
if (TempData.ContainsKey("SuccessMessage"))
    ViewBag.SuccessMessage = TempData["SuccessMessage"].ToString();

TempData["SuccessMessage"] = "Studentul cu numele " + student.Name + " a fost sters din baza de date";
TempData["ErrorMessage"] = "Error!";
```

Pentru a trece de validari, in controller se adauga
```C#
if (ModelState.IsValid)
```





## Viewuri
Mesaje:
```C#
@if (ViewBag.ErrorMessage != null)
{
    <div class="alert alert-warning alert-dismissable" role="alert">
        <h4 class="alert-heading">Warning</h4>
        <p>We were unable to perform the requested action!</p>
        <hr />
        <p><strong>Error Message:</strong> @ViewBag.ErrorMessage</p>
    </div>
}
@if (ViewBag.SuccessMessage != null)
{
    <div class="alert alert-success alert-dismissable" role="alert">
        <h4 class="alert-heading">Success</h4>
        <p>Successfully finished requested action!</p>
        <hr />
        <p><strong>Result Message:</strong> @ViewBag.SuccessMessage</p>
    </div>
}
<br />
```

Exemplu edit event:
```c#
@using Simulare3.Models
@model Event

@{
    var db = new ApplicationDbContext();
}

<h2>Edit Event</h2>

<form method="post" action="/Events/Edit">
    @Html.HttpMethodOverride(HttpVerbs.Put)
    @Html.HiddenFor(m => m.Id)

    @Html.ValidationSummary(false, "", new { @class = "text-danger" })
    
    @Html.LabelFor(m => m.Title, "Title of the Event")
    @Html.EditorFor(m => m.Title, null, new { @class = "form-control" })
    @Html.ValidationMessageFor(m => m.Title, null, new { @class = "text-danger" })
    
    @Html.DropDownListFor(m => m.LocationId,
            new SelectList(db.Locations.ToList(), "LocationId", "LocName"),
            "Select Location", new { @class = "form-control" })
    @Html.ValidationMessageFor(m => m.LocationId)
    <br />
    <button type="submit" class="btn btn-success">Edit Event</button>
</form>
```


## Helpere -> Curs 6
 * `Html.ActionLink` – genereaza un URL
 * `Html.TextBox` – genereaza un element de tipul TextBox
 * `Html.TextArea` – genereaza un element de tipul TextArea
 * `Html.CheckBox` – genereaza un element de tipul Check-box, util pentru valorile de tip boolean
 * `Html.RadioBox` – genereaza un element de tipul Radio button
 * `Html.DropDownList` –genereaza un element de tipul Dropdown, util pentru valorile de tip Enum
    ```C#
    @Html.DropDownListFor(m => m.CategoryId, new
        SelectList(Model.Categories, "Value", "Text"), "Selectati categoria", new { @class = "form-control" })
    ```

 * `Html.ListBox` – genereaza un element de tipul Dropdown cu selectie multipla
 * `Html.Hidden` – genereaza un input field ascuns
 * `Html.Password` – genereaza un camp pentru introducerea parolelor (textul introdus in camp este ascuns)
 * `Html.Display` – este util pentru afisarea textelor
 * `Html.Label` – genereaza un label pentru un element mentionat anterior
 * `Html.Editor` – acest helper genereaza unul din elementele de mai sus in functie de tipul proprietatii modelului. Astfel, daca editorul
    este alocat unui camp de tip int va genera un input de tip numeric; daca editorul este alocat unui camp de tip string va genera un
    textbox, etc.
 * `@using (Html.BeginForm(actionName: "Edit", controllerName: "Groups"))` - Creaza un form.
 
Exemplu de form Fara helpere:
```Html
<form method="post" action="/Students/New">
 @Html.HttpMethodOverride(HttpVerbs.Put)
 <label>Nume</label>
 <br />
 <input type="text" name="Name" />
 <br /><br />
 <label>Adresa e-mail</label>
 <br />
 <input type="text" name="Email" />
 <br /><br />
 <label>CNP</label>
 <br />
 <input type="text" name="CNP" />
 <br />
 <button type="submit">Adauga student</button>
</form>
```

Exemplu de input care transmite "ID" cu o anumita valoare:
```Html
<input type="hidden" name="id" value="@ev.Id" />
```

Exemplu de dropdown manual:
```Html
<select class="form-control" data-val="true" data-val-number="The field
CategoryId must be a number." data-val-required="The CategoryId field
is required." id="CategoryId" name="CategoryId">
 <option value="">Selectati categoria</option>
 <option value="2">Stiinta</option>
 <option value="8">Natura</option>
 <option value="9">Animale</option>
</select>
```


## Validari
```C#
[Required(ErrorMessage = "Campul e-mail este obligatoriu")]
[EmailAddress(ErrorMessage = "Adresa de e-mail nu este valida")]
[MinLength(13)]
[MaxLength(13)]
[DataType(DataType.Text)]
```

De adaugat in site.css
```CSS
.field-validation-valid {
 display: none;
}
.validation-summary-valid {
 display: none;
}
```



## Bootstrap
```Html
<div class="panel panel-default">
    <div class="panel-heading">@ev.Title</div>
    <div class="panel-body">
        <p><strong>Content:</strong> @ev.Description</p>
        <p><strong>Location:</strong> @ev.Location.LocName</p>
    </div>
    <div class="panel-footer" style="display:flex; grid-gap: 5px">
        <a class="btn btn-sm btn-success"
            href="/Events/Edit/@ev.Id">Editare Event</a>
        <form method="post" action="/Events/Delete/@ev.Id">
            @Html.HttpMethodOverride(HttpVerbs.Delete)
            <button type="submit" class="btn btn-danger">Sterge Event</button>
        </form>
    </div>
</div>
```


1. Don't forget to add hidden ID
2. Don't forget Db.SaveChanges()