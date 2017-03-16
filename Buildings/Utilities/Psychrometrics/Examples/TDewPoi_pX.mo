within Buildings.Utilities.Psychrometrics.Examples;
model TDewPoi_pX
  "Test the implementation of TDewPoi_pX"
  extends Modelica.Icons.Example;

  parameter Real wMax(min=0, max=1) = 0.1
    "The maximum humidity ratio to evaluate to";
                                          //0.0089757
  parameter Modelica.SIunits.Pressure p = 101325
    "Pressure to evaluate TDewPoi at; defaults to atmospheric pressure";

  Buildings.Utilities.Psychrometrics.TDewPoi_pX TDewPoi_pX(
    p=p, XSat=w);

  Modelica.SIunits.Temperature TDewPoi
  "The calculated dew point temperature";
  Real w(min=0, max=1)
    "Humidity ratio (kg water/kg moist air)";

equation
  w = min(wMax * time, wMax);
  TDewPoi = TDewPoi_pX.TDewPoi;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TDewPoi_pX;
