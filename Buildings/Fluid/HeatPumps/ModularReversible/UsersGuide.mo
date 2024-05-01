within Buildings.Fluid.HeatPumps.ModularReversible;
package UsersGuide
  "User's Guide for modular reversible heat pump and chiller models"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
  The packages <a href=\"modelica://Buildings.Fluid.HeatPumps\">Buildings.Fluid.HeatPumps</a>
  and <a href=\"modelica://Buildings.Fluid.Chillers\">Buildings.Fluid.Chillers</a> contain
  models for both reversible and non-reversible refrigerant
  machines (heat pumps and chillers) based on grey-box approaches.
  Either empirical data or physical equations are used to model
  the refrigerant cycle. The model for a refrigerant cycle calculates
  the electrical power consumption <code>PEle</code>,
  the condenser heat flow <code>QCon_flow</code>,
  and the evaporator heat flow <code>QEva_flow</code>
  based on available variables of the sink and source streams.
  Thus, this model does not enable closed-loop simulations of
  the refrigerant cycle. However, such models are
  highly demanding in terms computation time, and commercial implementations exist.
  When simulating the refrigerant machine in a more complex energy system,
  this modular approach enables detailed performance and
  dynamic behaviour and fast computating times.
</p>
<p>
  This user guide will help understand how to use the models associated
  with the modular approach.
  The approach was presented at the Modelica Conference 2021, see the section <b>References</b>.
</p>

<h4>Why modular models?</h4>
<p>
  Heat pumps and chillers are versatile machines:
</p>
<ul>
<li>
  They may use various source or sink media (e.g. air, water, brine, etc.);
</li>
<li>
  They may be on/off and inverter driven;
</li>
<li>
  They are able reverse the operation between heating to cooling;
</li>
<li>
  They operate in a limited characteristic range (operational envelope);
</li>
<li>
  The design depends on various nominal boundary conditions;
</li>
<li>
  Safety features are part of their control sequence.
</li>
</ul>
<p>
  To what extend all these effects need to be modeled depends
  on the simulation aim. Sometimes a simple Carnot approach is
  sufficient, sometimes a more detailed performance data
  and a realistic control behaviour is required.
</p>
<p>
  The modular approach allows to disable any irrelevant features,
  select readily made functional modules, and
  easily add new model modules.
  Relevant components are declared as <code>replaceable</code>.
  Replaceable models are <code>constrainedby</code> partial models
  which one is free to extend. Thus, new model approaches can be inserted
  into the framework of the modular reversible model approach.
  For users not familiar with replaceable models,
  there are readily assembled models as well.
</p>

<h4>Package and model structure</h4>

<p>
  This section explains the inheritance and model package structure
  to help navigate through all options and to check out the
  detailed documentation of each model for further information.
</p>
<p>
  All modular heat pump or chiller models base on the model
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle</a>.
  This partial model declares all common interfaces, parameters, etc.
</p>

<h5>Heat pump models</h5>
<p>
For heat pumps, the model <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Modular\">
Buildings.Fluid.HeatPumps.ModularReversible.Modular</a> extends the partial model and adds
the connector <code>hea</code> to choose
between the operation modes of the heat pump:
</p>
<ul>
<li><code>hea = true</code>: Main operation mode (heating) </li>
<li><code>hea = false</code>: Reversed operation mode (cooling) </li>
</ul>
<p>
Furthermore, the refrigerant cycle is redeclared to use the one for
the heat pump
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantCycle\">
Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantCycle</a>.
This refrigerant cycle in turn contains replaceable models for the
heating and cooling operation of the heat pump.
Available modules can be found in the package:
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle</a>
For more information on the refrigerant cycle models, refer
to the section <b>Refrigerant cycle models</b>.
</p>
<p>
  There are a number of preconfigured models provided in the package.
  Please check out the documentation of each approach
  to check if this approach is suitable.
</p>
<ul>
<li>
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.LargeScaleWaterToWater\">
  Buildings.Fluid.HeatPumps.ModularReversible.LargeScaleWaterToWater</a>
</li>
<li>
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.AirToWaterTableData2D\">
  Buildings.Fluid.HeatPumps.ModularReversible.AirToWaterTableData2D</a>
</li>
<li>
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.CarnotWithLosses\">
  Buildings.Fluid.HeatPumps.ModularReversible.CarnotWithLosses</a>
</li>
</ul>

<h5>Chiller models</h5>

<p>
For chillers, the model <a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.Modular\">
Buildings.Fluid.Chillers.ModularReversible.Modular</a> extends the partial model and adds
the connector <code>coo</code> to choose
between the operation mode of the chiller:
</p>
<ul>
<li><code>coo = true</code>: Main operation mode (cooling) </li>
<li><code>coo = false</code>: Reversed operation mode (heating) </li>
</ul>
<p>
Furthermore, the refrigerant cycle is redeclared to use the one for
the chiller
<a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.BaseClasses.RefrigerantCycle\">
Buildings.Fluid.Chillers.ModularReversible.BaseClasses.RefrigerantCycle</a>.
This refrigerant cycle in turn contains replaceable models for the
cooling and heating operation of the chiller.
Available modules can be found in the package:
<a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle\">
Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle</a>.
For more information on the refrigerant cycle models, refer
to the section <b>Refrigerant cycle models</b>.
</p>
<p>
  There are a number of preconfigured models provided in the package.
  Please check out the documentation of each approach
  to check if this approach is suitable.
</p>
<ul>
<li>
  <a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.LargeScaleWaterToWater\">
  Buildings.Fluid.Chillers.ModularReversible.LargeScaleWaterToWater</a>
</li>
<li>
  <a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.CarnotWithLosses\">
  Buildings.Fluid.Chillers.ModularReversible.CarnotWithLosses</a>
</li>
</ul>


<h4>Naming and reversible operation</h4>

<p>
Simulating reversible heat pumps and chillers can get confusing, as the same heat
exchanger model has to be used for both condensation and evaporation.
</p>

<p>
In most cases, heat pumps and chillers extract/exhaust heat from/to
an ambient source (air, soil, ground-water, etc.),
and, consuming electrical energy, provide heating or cooling 
on the <i>useful</i> or <i>load side</i>.
For building applications, this <i>useful / load side</i> is inside the building.
The ambient heat is outside of the building, on the <i>ambient / source side</i>.
However, vapor compression machines can also be used to provide heating 
and cooling simultaneously.
In this case, both sides provide utility to the energy system. 
Hence, both sides are <i>useful / load sides</i>.
</p>
<p>
What always stays the same is that there is one heated fluid, and
one cooled fluid. Thus, specifying the nominal temperatures, users have
to specify the temperatures of both heated and cooled fluids, for both cooling
and heating operation. Note, that the heated fluid will be the cooled fluid in
reversed operation, and vice versa.
</p>
<p>
Because of this, we decided on a naming scheme which is based on the main operation
of the heat pump or chiller. The main operation of a heat pump is heating, for
a chiller, it is cooling. When reversed, the condenser becomes the evaporator and
vice versa. As renaming instances after translation is not possible, users always
have to think about the names <code>con</code> and <code>eva</code> in terms of
the main operation of the device.
This applies to the instance and variable names,
such as the heat exchangers <code>con</code> and <code>eva</code>,
as well as sensors such as <code>TConOutMea</code> and <code>TEvaInMea</code>,
or nominal conditions <code>TConHea_nominal</code> and <code>TConCoo_nominal</code>.

As the nominal temperatures may be used table-based performance data
and the operational envelope model,
users also have to think about the <i>useful / load</i>
and <i>ambient / source side</i> and how they translate to
heat pumps and chillers in both main and reversed operation
when adding new datasheets.
Thinking about the heated and cooled fluid helps.
</p>
<p>
The following tables summarizes the possible options.
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
    <tr>
      <th></th>
      <th>Heat pump main</th>
      <th>Heat pump reversed</th>
      <th>Chiller main</th>
      <th>Chiller reversed </th>
    </tr>
    <tr>
      <td>Heating / cooling?</td>
      <td>heating</td>
      <td>cooling</td>
      <td>cooling</td>
      <td>heating  </td>
    </tr>
    <tr>
      <td>Table-data: column 1: useful / load side</td>
      <td><code>con</code></td>
      <td><code>con</code> <sup>1</sup></td>
      <td><code>eva</code></td>
      <td><code>eva</code> <sup>2</sup>  </td>
    </tr>
    <tr>
      <td>Table-data - row 1: ambient / source side</td>
      <td><code>eva</code></td>
      <td><code>eva</code> <sup>2</sup></td>
      <td><code>con</code></td>
      <td><code>con</code> <sup>1</sup>  </td>
    </tr>
    <tr>
      <td>Operational envelope - column 1: ambient / source side</td>
      <td><code>eva</code></td>
      <td><code>eva</code> <sup>2</sup></td>
      <td><code>con</code></td>
      <td><code>con</code> <sup>1</sup>  </td>
    </tr>
    <tr>
      <td>Operational envelope - column 2: useful / load side</td>
      <td><code>con</code></td>
      <td><code>con</code> <sup>1</sup></td>
      <td><code>eva</code></td>
      <td><code>eva</code> <sup>2</sup>  </td>
    </tr>
</table>
<b>Footnotes:</b>
<p>
<sup>1</sup> In reality, the condenser, e.g. a plate heat exchanger, of the main operation is used for evaporation.
<sup>2</sup> In reality, the evaporator, e.g. fin-tube heat exchanger, of the main operation is used for condensation.
</p>

<h4>Connectors</h4>

<p>
  Aside from the aforementioned Boolean signals
  <code>hea</code> and <code>coo</code>, the following
  connectors are relevant to understanding how the model works:
  Compressor speed and the expandable bus connector.

  The ambient temperatures <code>TEvaAmb</code> and <code>TConAmb</code> are
  only relevant for the heat losses.
  The fluid ports are explained in more detail here:
<a href=\"modelica://Buildings.Fluid.UsersGuide\">Buildings.Fluid.UsersGuide</a>.
</p>

<h5>Compressor speed</h5>

<p>
  The input <code>ySet</code> represents the relative compressor speed.
  To model both on/off and inverter controlled refrigerant machines,
  the compressor speed is normalised to a relative value between <i>0</i> and <i>1</i>.
  To model heat pumps other than inverter driven,
  other signal limits can be used.


  If data is in Hz or similar, consider converting
  the input according to the maximum allowed value.
</p>
<p>
  We use the notation <code>Set</code> to indicate a set value.
  It may be modified by the safety control blocks which produces a signal
  with the <code>Mea</code> notation. For example, the compressor
  speed <code>ySet</code> is modified by the safety 
  control block to <code>yMea</code>. If no safety violations
  occur, <code>ySet</code> equals <code>yMea</code>.
</p>

<h5>Expandable bus connector</h5>

<p>
  As the modular approach may require different information to model
  the refrigerant cycle depending on configuration, all available states and outputs
  are aggregated in the expandable bus connector <code>sigBus</code>.
  For instance, in order to control both chillers and heat pumps,
  both flow and return temperature are relevant.
</p>

<h4>Refrigerant cycle models</h4>

<p>
  A replaceable refrigerant cycle model for heating or
  cooling calculates the electrical power consumption
  <code>PEle</code>, condenser heat flow rate <code>QCon_flow</code>
  and evaporator heat flow rate <code>QEva_flow</code> based on the
  values in the <code>sigBus</code>.
  Heat pumps models extend
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle</a>
  and chiller models extend
  <a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle\">
  Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle</a>.
</p>
<p>
  Currently, two modules for refrigerant cycle are implemented.
  First, the <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantCarnotEffectiveness\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantCarnotEffectiveness</a> model
  uses the same equations as the Carnot models, i.e.  <a href=\"modelica://Buildings.Fluid.HeatPumps.Carnot_y\">
  Buildings.Fluid.HeatPumps.Carnot_y</a>.
  Second, the <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D</a> provides performance data
  based on different condenser outlet and evaporator inlet temperatures using 2D-tables.
</p>
<p>
  Two additional modules exist in the AixLib library.
  These approaches require the use of the SDF-library, as
  the compressor speed influences the model output as a third
  dimension. Currently, tables with more than two dimensions are not supported in
  the Modelica Standard Library.
  The first approach is similar to <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D</a>
  approach buts adds the 3rd dimension of compressor speed.
  The second approach is based on white-box stationary Python models
  for closed-loop refrigerant cycles. The model has been empirically
  validated and can take up to n-dimensions.
  If your simulation aim requires more detailed data, be sure
  to check out the models in the AixLib.
</p>


<h4>Parameterization and naming</h4>
<p>
  The refrigerant cycle models will output
  varying heat flow rates and electrical power consumptions.
  This is based on the fact that refrigerant cycle performance
  depend heavily on the boundary conditions.
</p>
<p>
  Still, the user needs to size the device or the system
  according to some reference points. Accordingly, we follow
  the basic Buildings concept for nominal conditions, explained in
  detail here:
  <a href=\"modelica://Buildings.Fluid.UsersGuide\">Buildings.Fluid.UsersGuide</a>
</p>
<p>
  The nominal heat flow rate of the device is distinct for 
  heat pumps and chillers.
  For heat pumps, it is the nominal
  condenser heat flow rate <code>QHea_flow_nominal</code>.
  For chillers, it is the nominal
  evaporator heat flow rate <code>QCoo_flow_nominal</code> (negative).
  This nominal heat flow rate is only valid at the
  nominal conditions. Whether parameters influence the nominal heat flow rates
  depends on the model approach used to estimate the heat flow rate and efficiencies.
  Typically, at least nominal source and sink temperatures will influence the 
  nominal conditions:
</p>
<ul>
<li>
  condenser temperature <code>TCon_nominal</code>,
</li>
<li>
  evaporator temperature <code>TEva_nominal</code>,
</li>
</ul>
<p>
  Depending on the model in use, this may be in- out outlet.
</p>
<p>
  Another example would be inverter driven devices.
  Here, the compressor speed influences the
  refrigerant mass flow rate and compressor efficiencies.
  If the performance data is dependent on the compressor speed,
  <code>y_nominal</code> influences the nominal efficiencies.
  In such cases, specifying additional nominal parameters will
  be nessary.
</p>
<p>
  Using the nominal conditions and the specified heat flow rate, 
  the nominal electrical power consumption <code>PEle_nominal</code> is calculated. 
  As reversible devices have typically a four-way-valve and a single
  compressor, you have to make sure that the values for <code>PEle_nominal</code> 
  are similar between heating and cooling. The pre-configured models 
  warn about deviations if they are too large.
</p>

<h4>Safety controls</h4>

<p>
  Refrigerant machines contain internal safety controls,
  prohibiting operations in possibly unsafe points.
  All <code>ModularReversible</code> models account for those.
  All options can be disabled as described in the model description
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Safety\">
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Safety</a>
</p>

<p>
  An important safety control with regard to
  system interaction is the operation envelope. Read the documentation of
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.PartialOperationalEnvelope\">
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.PartialOperationalEnvelope</a>
  for more information on this model and how it affects device operation.
</p>


<h4>Refrigerant cycle inertia</h4>

<p>
  The refrigerant cycle models
  are based on stationary data points, any inertia
  (mass and thermal) of components inside the refrigerant cycle
  (compressor, pipes, expansion valve, fluid, etc.) is neglected.
  To overcome this issue, replaceable SISO blocks that are connected to the
  output of the refrigerant cycle (instance <code>refCyc</code>)
  can approximate the refrigerant cycle inertia.
</p>
<p>
  The package
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias</a>
  contains implemented inertia models. In the
  <a href=\"https://doi.org/10.1016/j.enconman.2021.114888\">contribution</a>, an empirical
  validation showed that a third-order critical damping element
  fits the inertia most closely. At the same time, models in literature
  often use first-order delay blocks.
  Additionally, higher-order elements require more computation time.
  At the end, the requirements on the analysis will define the required level
  of detail of the model.
</p>
<p>
  The effect of the inertia can be removed by setting <code>NoInertia</code>.
</p>
<p>
  If a user finds in real data that another approach might be better suited
  (e.g. a deadband), then the model
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.BaseClasses.PartialInertia\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.BaseClasses.PartialInertia
  </a>
  can be extended to implement a costum model.
</p>


<h4>Frost</h4>

<p>
  To simulate possible icing of the evaporator on air-source devices, the
  icing factor <code>iceFac</code> is used to modify the outputs.
  The factor models the reduction of heat transfer between refrigerant
  and source. Thus, the factor is implemented as follows:
</p>
<p>
  <code>QEva_flow = iceFac * (QConNoIce_flow - PEle)</code>
</p>
<p>
  With <code>iceFac</code> as a relative value between <i>0</i> and <i>1</i>:
</p>
<p><code>iceFac = kA/kA_noIce</code></p>
<p>Finally, the energy balance must still hold:</p>
<p><code>QCon_flow = PEle + QEva_flow</code> </p>
<p>
  Different options can be selected for the modeling of the icing factor, or
  a custom model can be implemented by extending
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.BaseClasses.PartialIcingFactor\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.BaseClasses.PartialIcingFactor</a>
</p>
<p>
  Note however, that this only simulates the efficiency reduction
  due to frost. If a user-provided frost module enables the simulation
  of a defrost cycle, the user needs to implement the corresponding external controls.
  The <code>iceFac</code> approach was already used by Vering et al., 2021,
  to account for reverse cycle defrost based on validated literature-data.
  However, as no empirical validation was performed, the model was not
  added to the Buildings library.
</p>

<h4>Heat losses</h4>

<p>
  Most refrigerant cycle models that calculate
  <code>PEle</code>, <code>QCon_flow</code>, and <code>QEva_flow</code>
  assume the device to be adiabatic, following the equation:
</p>
<p>
  <code>QCon_flow = PEle + QEva_flow</code>
</p>
<p>
  Depending on the application, one may need to model
  the heat losses to the ambient, as those may
  impact the overall efficiency of the heat pump or chiller.
  Thus, the heat exchangers in the models adds
  thermal capacities to the adiabatic heat exchanger.
  The parameterization may be challenging, as datasheets
  do not contain parameters for the required values.
  Besides empirical calibration, simplified
  assumptions (e.g. <i>2%</i> heat loss) may be used to
  parameterize the required values.
  For more information, see the description of
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.EvaporatorCondenserWithCapacity\">
  Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.EvaporatorCondenserWithCapacity</a>
</p>

<h4>References</h4>
<p>
  Fabian Wuellhorst, David Jansen, Philipp Mehrfeld and Dirk Müller.<br/>
  A Modular Model of Reversible Heat Pumps and Chillers for System Applications.<br/>
  Proceedings of 14th Modelica Conference 2021. Linköping, Sweden, September, 2021.<br/>
  <a href=\"https://doi.org/10.3384/ecp21181561\">doi:10.3384/ecp21181561</a>.
</p>
<p>
Christian Vering, Fabian Wüllhorst, Philipp Mehrfeld and Dirk Müller.<br/>
Towards an integrated design of heat pump systems: Application of process intensification using two-stage optimization.<br/>
Energy Conversion and Management, Volume 250, 2021.<br/>
<a href=\"https://doi.org/10.1016/j.enconman.2021.114888\">doi:10.1016/j.enconman.2021.114888</a>.
</p>
</html>"));

end UsersGuide;
