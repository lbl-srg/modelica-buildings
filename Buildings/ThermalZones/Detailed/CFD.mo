within Buildings.ThermalZones.Detailed;
model CFD
  "Model of a room in which the air is computed using Computational Fluid Dynamics (CFD)"
  extends Buildings.ThermalZones.Detailed.BaseClasses.RoomHeatMassBalance(
  redeclare BaseClasses.CFDAirHeatMassBalance air(
    final massDynamics = massDynamics,
    final cfdFilNam = absCfdFilNam,
    final useCFD=useCFD,
    final samplePeriod=samplePeriod,
    final haveSensor=haveSensor,
    final nSen=nSen,
    final sensorName=sensorName,
    final portName=portName,
    final uSha_fixed=uSha_fixed,
    final p_start=p_start));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));

  parameter Boolean useCFD = true
    "Set to false to deactivate the CFD computation and use instead yFixed as output"
    annotation(Dialog(group = "CFD"), Evaluate = true);
  parameter Modelica.SIunits.Time samplePeriod(min=100*Modelica.Constants.eps)
    "Sample period of component"
    annotation(Dialog(group = "Sampling"));
  parameter Real uSha_fixed[nConExtWin] = zeros(nConExtWin)
    "Constant control signal for the shading device (0: unshaded; 1: fully shaded)";
  parameter String sensorName[:]
    "Names of sensors as declared in the CFD input file"
    annotation(Dialog(group = "CFD"));
  parameter String portName[nPorts] = {"port_" + String(i) for i in 1:nPorts}
    "Names of fluid ports as declared in the CFD input file"
    annotation(Dialog(group = "CFD"));
  parameter String cfdFilNam "CFD input file name"
    annotation (Dialog(group = "CFD",
        loadSelector(caption=
            "Select CFD input file")));
  Modelica.Blocks.Interfaces.RealOutput yCFD[nSen] if
       haveSensor "Sensor for output from CFD"
    annotation (Placement(transformation(
     extent={{460,110},{480,130}}), iconTransformation(extent={{200,110},{220, 130}})));
protected
  final parameter String absCfdFilNam = Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(cfdFilNam)
    "Absolute path to the CFD file";

  final parameter Boolean haveSensor = Modelica.Utilities.Strings.length(sensorName[1]) > 0
    "Flag, true if the model has at least one sensor";
  final parameter Integer nSen(min=0) = size(sensorName, 1)
    "Number of sensors that are connected to CFD output";
  Modelica.Blocks.Sources.Constant conSha[nConExtWin](final k=uSha_fixed) if
       haveShade "Constant signal for shade"
    annotation (Placement(transformation(extent={{-260,170},{-240,190}})));

equation
  connect(air.yCFD, yCFD) annotation (Line(
      points={{61,-142.5},{61,-206},{440,-206},{440,120},{470,120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conSha.y, conExtWin.uSha) annotation (Line(
      points={{-239,180},{328,180},{328,62},{281,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conSha.y, bouConExtWin.uSha) annotation (Line(
      points={{-239,180},{328,180},{328,64},{351,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conSha.y, conExtWinRad.uSha) annotation (Line(
      points={{-239,180},{420,180},{420,-42},{310.2,-42},{310.2,-25.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(irRadGai.uSha,conSha.y)
                             annotation (Line(
      points={{-100.833,-22.5},{-112,-22.5},{-112,180},{-239,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conSha.y, radTem.uSha) annotation (Line(
      points={{-239,180},{-112,180},{-112,-62},{-100.833,-62},{-100.833,-62.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conSha.y, shaSig.u) annotation (Line(
      points={{-239,180},{-228,180},{-228,160},{-222,160}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(air.uSha,conSha.y)  annotation (Line(
      points={{39.6,-120},{28,-120},{28,180},{-239,180}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}}),
                               graphics={Rectangle(
          extent={{-140,138},{140,78}},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Bitmap(
          extent={{-140,168},{150,-170}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/Detailed/cfd.png"),
        Text(
          extent={{162,98},{196,140}},
          lineColor={0,0,127},
          textString="yCFD"),
        Text(
          extent={{-86,-14},{0,16}},
          lineColor={0,0,0},
          textString="air"),
        Text(
          extent={{-102,-50},{-22,-26}},
          lineColor={0,0,0},
          textString="radiation"),
        Text(
          extent={{-114,-134},{-36,-116}},
          lineColor={0,0,0},
          textString="surface")}),
    Documentation(info="<html>
<p>
Room model that computes the room air flow using computational fluid dynamics (CFD). The CFD simulation is coupled to the thermal simulation of the room
and, through the fluid port, to the air conditioning system.
</p>
<p>
Currently, the supported CFD program is the
Fast Fluid Dynamics (FFD) program <a href=\"#ZUO2010\">(Zuo 2010)</a>.
See
<a href=\"modelica://Buildings.ThermalZones.Detailed.UsersGuide\">Buildings.ThermalZones.Detailed.UsersGuide</a>
for detailed explanations.
</p>
<h4>References</h4>
<p>
<a name=\"ZUO2010\"/>
Wangda Zuo. <a href=\"http://docs.lib.purdue.edu/dissertations/AAI3413824/\">
Advanced simulations of air distributions in buildings</a>.
Ph.D. Thesis, School of Mechanical Engineering, Purdue University, 2010.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 2, 2016, by Michael Wetter:<br/>
Refactored implementation of latent heat gain.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/515\">issue 515</a>.
</li>
<li>
April 21, 2016, by Michael Wetter:<br/>
Added parameter <code>absCfdFilNam</code> as the call to
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath\">
Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath</a>
was removed from
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange\">
Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange</a>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">Buildings, #506</a>.
</li>
<li>
August 1, 2013, by Michael Wetter and Wangda Zuo:<br/>
First Implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-260,-220},{460,
            200}}), graphics));
end CFD;
