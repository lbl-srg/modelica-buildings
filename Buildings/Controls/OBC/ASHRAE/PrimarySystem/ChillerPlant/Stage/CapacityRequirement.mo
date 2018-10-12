within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage;
block CapacityRequirement
  "Required cooling capacity at given flow, chilled water return and supply setpoint temperatures"

  parameter Real water_density(quantity="Density", unit="kg/m3") = 1
  "Water density";

  parameter Real water_cp = 4184
  "Specific heat capacity of water Fixme: unit and quantity";

  parameter Modelica.SIunits.Time avePer = 5*60
  "Period for the rolling average";

  CDL.Interfaces.RealInput TChiWatSupSet(final unit="K", final quantity="ThermodynamicTemperature")
    "Chilled water supply setpoint temperature" annotation (Placement(
        transformation(extent={{-140,60},{-100,100}}), iconTransformation(
          extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.RealInput                        TChiWatRet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-120,20},{-100,40}})));
  CDL.Interfaces.RealInput VChiWat_flow(final quantity="VolumeFlowRate", final
      unit="m3/s") "Measured chilled water flow rate" annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}), iconTransformation(
          extent={{-120,24},{-100,44}})));
  CDL.Continuous.Add add2(k1=-1)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  CDL.Interfaces.RealOutput yCapReq
    "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  CDL.Continuous.MovingMean movMea(delta=avePer)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(TChiWatRet, add2.u2) annotation (Line(points={{-120,20},{-60,20},{-60,
          24},{-42,24}}, color={0,0,127}));
  connect(add2.u1, TChiWatSupSet) annotation (Line(points={{-42,36},{-60,36},{-60,
          80},{-120,80}}, color={0,0,127}));
  connect(add2.y, pro.u1) annotation (Line(points={{-19,30},{-10,30},{-10,6},{-2,
          6}}, color={0,0,127}));
  connect(VChiWat_flow, pro.u2) annotation (Line(points={{-120,-60},{-60,-60},{-60,
          -6},{-2,-6}}, color={0,0,127}));
  connect(pro.y, movMea.u)
    annotation (Line(points={{21,0},{38,0}}, color={0,0,127}));
  connect(yCapReq, movMea.y)
    annotation (Line(points={{110,0},{61,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CapacityRequirement;
