within Buildings.Fluid.HeatExchangers.Borefield.Data.Records;
record General "General parameters of the borefield"
  extends Modelica.Icons.Record;
  import SI = Modelica.SIunits;

  parameter String pathMod = "Buildings.Fluid.HeatExchangers.Borefield.Data.Records.General"
    "Modelica record path";
  parameter String pathCom = Modelica.Utilities.Files.loadResource("modelica://Buildings/Fluid/HeatExchangers/Borefield/Data/Records/General.mo")
    "Computer record path";

  parameter SI.Temperature T_start = 283.15
    "Initial temperature of the borefield (grout and soil)";
  parameter SI.MassFlowRate m_flow_nominal_bh = 0.3
    "Nominal mass flow rate per borehole";
    parameter SI.Pressure dp_nominal=50000
    "Pressure losses for the entire borefield";

  //------------------------- Geometrical parameters -----------------------------------------------------------------------------------------------------------------------------
  // -- Borefield geometry
  parameter SI.Height hBor=100 "Total height of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter SI.Radius rBor=0.1 "Radius of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter Integer nbBh=1 "Total number of boreholes"
    annotation (Dialog(group="Borehole"));

  parameter Integer nbSer=1
    "DO NOT CHANGE! NOT YET SUPPORTED. Number of boreholes in series."
    annotation (Dialog(group="Borehole"));

  parameter Real[nbBh,2] cooBh={{0,0}}
    "Cartesian coordinates of the boreholes in meters."
    annotation (Dialog(group="Borehole"));

  // -- Tube
  parameter SI.Radius rTub=0.02 "Radius of the tubes"
    annotation (Dialog(group="Tubes"));
  parameter SI.ThermalConductivity kTub=0.5 "Thermal conductivity of the tube"
    annotation (Dialog(group="Tubes"));

  parameter SI.Length eTub=0.002 "Thickness of a tube"
    annotation (Dialog(group="Tubes"));

  parameter SI.Length xC=0.05
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole"
    annotation (Dialog(group="Tubes"));

  //------------------------- Step reponse parameters -----------------------------------------------------------------------------------------------------------------------------
  parameter SI.Time tStep=3600 "Time resolution of the step-response [s]";
  final parameter Integer tSteSta_d=integer(3600*24*365*30/tStep)
    "Discrete time to reach steady state [-] (default = 30 years)";
  final parameter Integer tBre_d= max(1,integer(150*3600 / tStep))
    "Discrete time upper boundary for saving results [-] (tBre_d * tStep) should be >= 150 hours";
  parameter Real q_ste(unit="W/m") = 30
    "Power per length borehole of step load input";

  //------------------------- Advanced parameters -----------------------------------------------------------------------------------------------------------------------------

  /*--------Discretization: */
  parameter Integer nVer=1
    "DO NOT CHANGE! NOT YET SUPPORTED. Number of segments used for discretization in the vertical direction. Only important for the short-term simulation. nVer>1 not yet supported"
    annotation (Dialog(tab="Discretization"));
  parameter Integer nHor(min=1) = 10
    "Number of state variables in each horizontal layer of the soil"
    annotation (Dialog(tab="Discretization"));
  final parameter SI.Height hSeg=hBor/nVer "Height of horizontal element"
    annotation (Dialog(tab="Discretization"));

  /*--------Flow: */
  parameter SI.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal_bh)
    "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Nominal condition"));

  /*--------Boundary condition: */
  /*----------------T_start: */
  /*------------------------Ground: */
  parameter SI.Height z0=0
    "NOT YET SUPPORTED. Depth below which the temperature gradient starts"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));
  parameter SI.Height z[nVer]={hBor/nVer*(i - 0.5) for i in 1:nVer}
    "NOT YET SUPPORTED. Distance from the surface to the considered segment"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));
  parameter Real dT_dz(unit="K/m") = 0.0
    "NOT YET SUPPORTED. Vertical temperature gradient of the undisturbed soil for h below z0"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));

  parameter SI.Radius rExt=3
    "Radius of the soil used for the external boundary condition"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));

  parameter SI.Temperature TExt0_start=T_start "Initial far field temperature"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));

  parameter SI.Temperature TExt_start[nVer]={if z[i] >= z0 then TExt0_start + (
      z[i] - z0)*dT_dz else TExt0_start for i in 1:nVer}
    "Temperature of the undisturbed ground"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));

  /*------------------------Filling:*/
  parameter SI.Temperature TFil0_start=TExt0_start
    "Initial temperature of the filling material for h = 0...z0"
    annotation (Dialog(tab="Boundary conditions", group="T_start: filling"));

  /*--------Assumptions: */
  parameter Boolean allowFlowReversal=true
    "True to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumption"), Evaluate=true);

  parameter SI.Pressure p_constant=101300;

  final SI.Volume volOneLegSeg = hSeg*Modelica.Constants.pi*rTub^2
    "Volume of brine in one leg of a segment";
 annotation (Documentation(info="<html>
 <p>General parameters of the borefield and record path.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end General;
