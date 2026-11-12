within Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting;
block Controller "Controller"

  parameter Integer nAHU(min=1)
    "Number of air handling units";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_flow[nAHU]
    "Volumetric air flow for the variable air volume served by the air handling unit"
    annotation (Placement(transformation(extent={{-140,160},{-100,200}}),
                         iconTransformation(extent={{-140,160},{-100,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput fanSpe[nAHU](each unit="1")
    "Fan speed of the air handling unit"
    annotation (Placement(transformation(extent={{-140,120},{-100,160}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[nAHU](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Zone temperature for the zone served by the air handling unit"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBuiRedTar(final unit="W",
      final quantity="Power")
    "Target electricity demand reduction of the building" annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}),   iconTransformation(
          extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput fanSpeLimCur[nAHU](unit="1")
    "Current fan speed limit" annotation (Placement(transformation(extent={{-140,
            -40},{-100,0}}), iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput fanSpeLimCom[nAHU](unit="1")
    "Commanded fan speed limit" annotation (Placement(transformation(extent={{100,
            -20},{140,20}}), iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBuiRed(final unit="W",
      final quantity="Power")
    "Electricity demand reduction of the building, defined as the counterfactual baseline electricity demand minus the actual eletricity demand "
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput fanSpeLimDef[nAHU](unit="1")
    "Default fan speed limit" annotation (Placement(transformation(extent={{-140,
            -120},{-100,-80}}), iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput fanSpeLimTarShe[nAHU](unit="1")
    "Target fan speed limit for the load-shed mode" annotation (Placement(
        transformation(extent={{-140,-160},{-100,-120}}), iconTransformation(
          extent={{-140,-160},{-100,-120}})));
  annotation (defaultComponentName="con",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{100,200}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,200},{100,-200}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,242},{100,202}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2},
        extent={{-100,-200},{100,200}})),
    Documentation(revisions="<html>
<ul>
<li>
October 21, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Passes a Boolean signal through without modification.
</p>
</html>"));
end Controller;
