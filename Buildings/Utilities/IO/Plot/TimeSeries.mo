within Buildings.Utilities.IO.Plot;
block TimeSeries "Block that plots one or multiple time series"
  parameter Modelica.SIunits.Time samplePeriod(min=1E-3)
    "Sample period of component";
  parameter Integer n(min=1) "Number of time series to be plotted";
  parameter String title "Title of the plot";
  parameter String[n] legend "String array for legend, such as {\"x1\", \"x2\"}";
  Modelica.Blocks.Interfaces.RealInput u[n] "Time series to be plotted" annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  parameter String fileName = "test.html" "Name of html file";
protected
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";

  output Boolean sampleTrigger "True, if sample time instant";

  output Boolean firstTrigger(start=false, fixed=true)
    "Rising edge signals first sample instant";
  Buildings.Utilities.IO.Plot.BaseClasses.Backend plt=
    Buildings.Utilities.IO.Plot.BaseClasses.Backend(fileName=fileName)
    "Object that stores data for this plot";
  String str "Temporary string";

initial equation
  t0 = time;
initial algorithm
  Modelica.Utilities.Files.removeFile(fileName=fileName);
  Buildings.Utilities.IO.Plot.BaseClasses.print(
    plt=plt,
    string="
<head>
  <!-- Plotly.js -->
  <script src=\"https://cdn.plot.ly/plotly-latest.min.js\"></script>
</head>
<body>
    <div id=\"myDiv\"><!-- Plotly chart will be drawn inside this DIV --></div>
    <script>
    ",
    finalCall = false);
algorithm
  sampleTrigger :=sample(t0, samplePeriod);
  when sampleTrigger then
    firstTrigger :=time <= t0 + samplePeriod/2;
  end when;

  when terminal() then
  str :="];
  ";
  for i in 1:n loop
    str := str + "
  const x" + String(i) + " = {
    x: allData.map(x => x[0]),
    y: allData.map(x => x[" + String(i) + "]),
    type: 'scatter',
    name: '" + legend[i] + "'
  };";
  end for;
  str :=str + "
  var data = [";
  for i in 1:n loop
    str := str + "x" + String(i);
    if i < n then
      str := str + ",";
    else
      str := str + "];";
    end if;
  end for;
  str := str + "
  var layout = { 
    title: '" + title + "',
    xaxis: { title: 'time [s]'}
    };
  Plotly.newPlot('myDiv', data, layout);
    </script>
  </body>
  ";

  Buildings.Utilities.IO.Plot.BaseClasses.print(
    plt=plt,
    string=str,
    finalCall = true);
  elsewhen {sampleTrigger} then
    str :="";
    for i in 1:n loop
      str :=str + ", " + String(u[i]);
    end for;
    if time <= t0 + samplePeriod/2 then
      Buildings.Utilities.IO.Plot.BaseClasses.print(
      plt=plt,
      string=
        "const allData = [[" + String(time) + str + "]",
        finalCall = false);
    else
      Buildings.Utilities.IO.Plot.BaseClasses.print(
      plt=plt,
      string= ", [" + String(time) + str + "]",
      finalCall = false);
    end if;
  end when;
end TimeSeries;
