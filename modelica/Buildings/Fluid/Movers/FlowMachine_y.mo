within Buildings.Fluid.Movers;
model FlowMachine_y "Pump or fan with ideally controlled normalized speed"
  extends Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
  final N_nominal=1500 "fix N_nominal as it is used only for scaling",
  redeclare replaceable function flowCharacteristic = 
      Buildings.Fluid.Movers.BaseClasses.Characteristics.baseFlow);
  parameter Boolean use_y_in = true
    "Get the rotational speed from the input connector";
  parameter Real y_const(min=0, max=1) = 1
    "Constant normalized rotational speed" annotation(Dialog(enable = not use_y_in));
  Modelica.Blocks.Interfaces.RealInput y_in(min=0, max=1) if use_y_in
    "Constant normalized rotational speed" 
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));
  annotation (defaultComponentName="fan",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={Text(
          visible=use_N_in,
          extent={{14,98},{178,82}},
          textString="y_in [0, 1]")}),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}), graphics),
    Documentation(info="<HTML>
<p>This model describes a centrifugal pump (or a group of <tt>nParallel</tt> pumps) with prescribed speed, either fixed or provided by an external signal.
<p>If the <tt>y_in</tt> input connector is wired, it provides the normalized rotational speed of the pumps (between 0 and 1); otherwise, a constant rotational speed equal to <tt>y_const</tt> is assumed.</p>
</HTML>",
      revisions="<html>
<ul>
<li><i>October 1, 2009</i>
    by Michael Wetter:<br>
       Model added to the Buildings library. Changed control signal from rpm to normalized value between 0 and 1</li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Model added to the Fluid library</li>
</ul>
</html>"));

protected
  Modelica.Blocks.Interfaces.RealInput y_in_internal(min=0, max=1)
    "Needed to connect to conditional connector";
equation
  // Connect statement active only if use_y_in = true
  connect(y_in, y_in_internal);
  // Internal connector value when use_p_in = false
  if not use_y_in then
    y_in_internal = y_const;
  end if;
  // Set N with a lower limit to avoid singularities at zero speed
  N = max(y_in_internal*N_nominal,1e-3) "Rotational speed";

end FlowMachine_y;
