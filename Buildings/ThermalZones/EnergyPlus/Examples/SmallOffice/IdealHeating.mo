within Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice;
model IdealHeating "Building with constant fresh air and ideal heating/cooling that exactly meets set point"
  extends Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.NoHVAC;

  IdealHeater[5] hea(
    Q_flow_nominal= 100*{flo.AFloSou, flo.AFloEas, flo.AFloNor, flo.AFloWes, flo.AFloCor})
      "Ideal heater" annotation (
      Placement(transformation(rotation=0, extent={{-10,70},{10,90}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSet[5](each k=293.15)
    "Set point temperature"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  Controls.OBC.CDL.Continuous.MultiSum QHea_flow(nin=5) "Total heat flow rate"
    annotation (Placement(transformation(extent={{30,90},{50,110}})));
  Modelica.Blocks.Continuous.Integrator EHea "Heating energy"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
equation

protected
  model IdealHeater "Model of ideal heater"
    extends Modelica.Blocks.Icons.Block;

    parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal "Maximum heat flow rate";

    Controls.OBC.CDL.Continuous.PID conPID(
      controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
      Ti=120,
      yMin=-1) "Controller for heat input"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Controls.OBC.CDL.Continuous.Gain gai(k=Q_flow_nominal)
      "Gain for heat flow rate"
      annotation (Placement(transformation(extent={{20,-10},{40,10}})));
    HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));
    Controls.OBC.CDL.Interfaces.RealInput TSet "Set point temperature"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
          iconTransformation(extent={{-140,-20},{-100,20}})));
    Controls.OBC.CDL.Interfaces.RealInput TMea "Measured temperature" annotation (
       Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={0,-120}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={0,-120})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPor "Heat port"
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    Controls.OBC.CDL.Interfaces.RealOutput Q_flow(final unit = "W") "Heat flow rate"
      annotation (Placement(transformation(extent={{100,40},{140,80}})));
  equation
    connect(conPID.u_s, TSet)
      annotation (Line(points={{-12,0},{-120,0}}, color={0,0,127}));
    connect(conPID.u_m, TMea)
      annotation (Line(points={{0,-12},{0,-120}}, color={0,0,127}));
    connect(preHeaFlo.Q_flow, gai.y)
      annotation (Line(points={{60,0},{42,0}}, color={0,0,127}));
    connect(gai.u, conPID.y)
      annotation (Line(points={{18,0},{12,0}}, color={0,0,127}));
    connect(preHeaFlo.port, heaPor)
      annotation (Line(points={{80,0},{100,0}}, color={191,0,0}));
    connect(gai.y, Q_flow) annotation (Line(points={{42,0},{50,0},{50,60},{120,60}},
          color={0,0,127}));
      annotation (
      defaultComponentName = "ideHea",
      Documentation(info="<html>
<p>
Model of an ideal heater that tracks a set point using a PI controller.
</p>
</html>", revisions="<html>
<ul>
<li>
March 4, 2021, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2381\">#2381</a>.
</li>
</ul>"));
  end IdealHeater;
equation
  connect(flo.TRooAir, hea.TMea) annotation (Line(points={{87.1739,13},{92,13},
          {92,60},{0,60},{0,68}}, color={0,0,127}));
  connect(TSet.y, hea.TSet)
    annotation (Line(points={{-28,80},{-12,80}}, color={0,0,127}));
  connect(hea[1].heaPor, flo.heaPorSou) annotation (Line(points={{10,80},{64,80},
          {64,4.23077},{57.5913,4.23077}}, color={191,0,0}));
  connect(hea[2].heaPor, flo.heaPorEas) annotation (Line(points={{10,80},{
          79.8957,80},{79.8957,15.7692}}, color={191,0,0}));
  connect(hea[3].heaPor, flo.heaPorNor) annotation (Line(points={{10,80},{64,80},
          {64,20.6154},{57.3565,20.6154}}, color={191,0,0}));
  connect(hea[4].heaPor, flo.heaPorWes) annotation (Line(points={{10,80},{
          38.3391,80},{38.3391,15.7692}}, color={191,0,0}));
  connect(hea[5].heaPor, flo.heaPorCor) annotation (Line(points={{10,80},{64,80},
          {64,12.7692},{57.8261,12.7692}}, color={191,0,0}));
  connect(hea.Q_flow, QHea_flow.u[1:5]) annotation (Line(points={{12,86},{20,86},
          {20,100},{28,100},{28,98.4}}, color={0,0,127}));
  connect(QHea_flow.y, EHea.u)
    annotation (Line(points={{52,100},{58,100}}, color={0,0,127}));
    annotation (
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/SmallOffice/IdealHeating.mos"
        "Simulate and plot"),
experiment(
      StartTime=432000,
      StopTime=864000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
Documentation(info="<html>
<p>
Test case of the small office DOE reference building without an HVAC system
but an ideal heating/cooling device that exactly meets the load.
</p>
</html>", revisions="<html>
<ul>
<li>
March 4, 2021, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2381\">#2381</a>.
</li>
</ul>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,120}})));
end IdealHeating;
