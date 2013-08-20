within Buildings.Rooms;
model FFD
  "Model of a room in which the air is computed using fast fluid flow dynamics"
  extends Buildings.Rooms.BaseClasses.RoomHeatMassBalance(
  redeclare BaseClasses.CFDAirHeatMassBalance air(
    final useFFD=useFFD,
    final samplePeriod=samplePeriod,
    final startTime=startTime,
    final haveSensor=haveSensor,
    final nSen=nSen,
    final sensorName=sensorName,
    final portName=portName),
    final energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial);

  parameter Boolean useFFD = true
    "Set to false to deactivate the FFD computation and use instead yFixed as output"
    annotation(Evaluate = true);

  parameter Modelica.SIunits.Time samplePeriod(min=100*Modelica.Constants.eps)
    "Sample period of component"
    annotation(Dialog(group = "Sampling"));
  parameter Modelica.SIunits.Time startTime
    "First sample time instant. fixme: this should be at first step."
    annotation(Dialog(group = "Sampling"));

  parameter String sensorName[:] = {""}
    "Names of sensors as declared in the CFD input file";
  parameter String portName[nPorts]
    "Names of fluid ports as declared in the CFD input file";
  parameter String cfddFilNam "CFD input file name" annotation (Dialog(
        __Dymola_loadSelector(caption=
            "Select CFD input file")));
  Modelica.Blocks.Interfaces.RealOutput yCFD[nSen] if
       haveSensor "Sensor for output from CFD"
    annotation (Placement(transformation(
     extent={{460,110},{480,130}}), iconTransformation(extent={{200,110},{220, 130}})));

protected
  BaseClasses.CFDHeatGain heaGai(final AFlo=AFlo)
    "Model to convert internal heat gains"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));

protected
  final parameter Boolean haveSensor = Modelica.Utilities.Strings.length(sensorName[1]) > 0
    "Flag, true if the model has at least one sensor";
  final parameter Integer nSen(min=0) = size(sensorName, 1)
    "Number of sensors that are connected to CFD output";
equation
  connect(qGai_flow, heaGai.qGai_flow) annotation (Line(
      points={{-280,80},{-250,80},{-250,100},{-222,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaGai.QRad_flow, add.u2) annotation (Line(
      points={{-198,106},{-152,106},{-152,114},{-142,114}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(air.QCon_flow, heaGai.QCon_flow) annotation (Line(
      points={{39,-135},{-14,-135},{-14,-92},{-190,-92},{-190,100},{-198,100}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(air.QLat_flow, heaGai.QLat_flow) annotation (Line(
      points={{39,-138},{-18,-138},{-18,-94},{-194,-94},{-194,94},{-198,94},{
          -198,94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(air.yCFD, yCFD) annotation (Line(
      points={{61,-142.5},{61,-206},{440,-206},{440,120},{470,120}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}}),
                               graphics={Rectangle(
          extent={{-140,138},{140,78}},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid), Text(
          extent={{162,98},{196,140}},
          lineColor={0,0,127},
          textString="yCFD")}),
    Documentation(info="<html>
<p>
Room model that assumes the air to be completely mixed. 
</p>
<p>
See 
<a href=\"modelica://Buildings.Rooms.UsersGuide\">Buildings.Rooms.UsersGuide</a>
for detailed explanations.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 1, 2013, by Michael Wetter:<br/>
Introduced base class
<a href=\"modelica://Buildings.Rooms.BaseClasses.RoomHeatMassBalance\">
Buildings.Rooms.BaseClasses.RoomHeatMassBalance</a>
as the latent heat gains are treated differently in the mixed air and in the CFD model.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-260,-220},{460,
            200}}), graphics));
end FFD;
