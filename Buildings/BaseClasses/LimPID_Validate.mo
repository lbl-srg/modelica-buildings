within Buildings.BaseClasses;
model LimPID_Validate
extends Modelica.Icons.Example;
  LimPID_1 conPID(
    Td=60,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    yMax=1,
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=600,
    k=0.01) "Controller for cooling coil" annotation (Placement(transformation(extent={{-32,4},
            {-12,24}})));
protected
  Modelica.Blocks.Sources.Constant Dzero(final k=1.2)
    "Zero input signal"
    annotation(Evaluate=true, HideResult=true,
               Placement(transformation(extent={{-80,8},{-70,18}})));
  Modelica.Blocks.Sources.Constant Dzero1(final k=1.0)
    "Zero input signal"
    annotation(Evaluate=true, HideResult=true,
               Placement(transformation(extent={{-66,-22},{-56,-12}})));
equation
  connect(Dzero.y, conPID.u_s) annotation (Line(points={{-69.5,13},{-52.75,13},
          {-52.75,14},{-34,14}},
                        color={0,0,127}));
  connect(Dzero1.y, conPID.u_m)
    annotation (Line(points={{-55.5,-17},{-22,-17},{-22,2}},
                                                          color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LimPID_Validate;
