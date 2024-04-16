within Buildings.Fluid.Dehumidifiers.Desiccant.Data;
record Generic "Generic data record for desiccant dehumidifiers"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.Temperature TRegEnt_nominal
    "Nominal temperature of the regeneration air entering the dehumidifier";
  parameter Modelica.Units.SI.Temperature TProEnt_max
    "Maximum allowable temperature of the process air entering the dehumidifier";
  parameter Modelica.Units.SI.Temperature TProEnt_min
    "Minimum allowable temperature of the process air entering the dehumidifier";
  parameter Modelica.Units.SI.MassFraction X_w_ProEnt_max
    "Maximum allowable humidity ratio of the process air entering the dehumidifier";
  parameter Modelica.Units.SI.MassFraction X_w_ProEnt_min(
     final min=0)
    "Minimum allowable humidity ratio of the process air entering the dehumidifier";
  parameter Real coeTProLea[16]
    "Coefficients for calculating the temperature of the process air leaving the dehumidifier";
  parameter Real coeX_w_ProLea[16]
    "Coefficients for calculating the humidity ratio of the process air leaving the dehumidifier";
  parameter Real coevReg[16]
    "Coefficients for calculating the velocity of the regeneration air";
  parameter Real coeQReg_flow[16]
    "Coefficients for calculating the regeneration heat flow";

  annotation (Documentation(info="<html>
<p>This record is used as a template for performance data
for the desiccant dehumidifier models in
<a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant\">
Buildings.Fluid.Dehumidifiers.Desiccant</a>.
</p>
</html>", revisions="<html>
<ul>
<li>March 1, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
