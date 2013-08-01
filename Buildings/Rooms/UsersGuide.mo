within Buildings.Rooms;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The package <b>Buildings.Rooms</b> contains models for heat transfer 
through the building envelope.
Multiple instances of these models can be connected to create
a multi-zone building model.
To compute the air exchange between rooms and between a room
and the exterior, the room models can be connected to 
multi-zone air exchange models from the package
<a href=\"modelica://Buildings.Airflow\">
Buildings.Airflow</a>.
The room models can also be linked to models of HVAC systems
that are composed of the components in the package
<a href=\"modelica://Buildings.Fluid\">
Buildings.Fluid</a>.
</p>
</html>"));


   class MixedAir "Room model with instantaneously mixed air"
    extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>The model <a href=\"modelica://Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a> is 
a model of a room with completely mixed air.
The room can have any number of constructions and surfaces that participate in the 
heat exchange through convection, conduction, infrared radiation and solar radiation.</p>
<h4>Physical description</h4>
<p>
A description of the model assumptions and the implemention and validation of this room model can be found in 
<a href=\"#WetterEtAl2011\">Wetter et al. (2011)</a>.
Note that this paper describes a previous version of the room model. 
The equations have not changed. However, what is shown in Figure 2 in the paper has in this version
of the model been integrated directly into what is shown in Figure 1.</p>
<p>
The room models the following physical processes:
</p>
<ol>
<li>
Transient or steady-state heat conduction through opaque surfaces, using
the model
<a href=\"modelica://Buildings.HeatTransfer.Conduction.MultiLayer\">
Buildings.HeatTransfer.Conduction.MultiLayer</a>
</li>
<li>
Heat transfer through glazing system, taking into account
solar radiation, infrared radiation, heat conduction and heat convection.
The solar radiation is modeled using
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.WindowRadiation\">
Buildings.HeatTransfer.Windows.BaseClasses.WindowRadiation</a>.
The overall heat transfer is modeled using the model
<a href=\"modelica://Buildings.HeatTransfer.Windows.Window\">
Buildings.HeatTransfer.Windows.Window</a>
for the glass assembly, and the models
<a href=\"modelica://Buildings.HeatTransfer.Windows.ExteriorHeatTransfer\">
Buildings.HeatTransfer.Windows.ExteriorHeatTransfer</a>
and
<a href=\"modelica://Buildings.HeatTransfer.Windows.InteriorHeatTransfer\">
Buildings.HeatTransfer.Windows.InteriorHeatTransfer</a>
for the exterior and interior heat transfer.
A window can have both, an overhang and a side fin.
Overhangs and side fins are modeled using
<a href=\"modelica://Buildings.HeatTransfer.Windows.Overhang\">
Buildings.HeatTransfer.Windows.Overhang</a> and
<a href=\"modelica://Buildings.HeatTransfer.Windows.SideFins\">
Buildings.HeatTransfer.Windows.SideFins</a>, respectively.
These models compute the reduction in direct solar irradiation 
due to the external shading device.
</li>
<li>
Convective heat transfer between the outside air and outside-facing surfaces using
either a wind-speed, wind-direction and temperature-dependent heat transfer coefficient,
or using a constant heat transfer coefficient, as described in
<a href=\"modelica://Buildings.HeatTransfer.Convection.Exterior\">
Buildings.HeatTransfer.Convection.Exterior</a>.
</li>
<li>
Solar and infrared heat transfer between the room enclosing surfaces,
convective heat transfer between the room enclosing surfaces and the room air,
and temperature, pressure and species balance inside the room volume.
These effects are modeled as follows:
<ol>
<li>
The model 
<a href=\"modelica://Buildings.Rooms.BaseClasses.AirHeatMassBalanceMixed\">
Buildings.Rooms.BaseClasses.AirHeatMassBalanceMixed</a>
is used to compute heat convection between the room air
and the surface of opaque constructions. It is also used to compute the
heat and mass balance of the room air.
This model is a composite model that contains 
<a href=\"modelica://Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective\">
Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective</a> to compute the convective
heat balance of the window and a shade, if present.
The convective heat transfer coefficient can be selected to be
either temperature-dependent or constant.
The convective heat transfer is computed using
<a href=\"modelica://Buildings.HeatTransfer.Convection.Interior\">
Buildings.HeatTransfer.Convection.Interior</a>.
The heat and mass balance of the room air is computed using
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>,
which assumes the room air to be completely mixed.
Depending on the medium model, moisture and species concentrations,
such as CO<sub>2</sub>, can be modeled transiently.
</li>
<li>
The latent heat gain of the room, which is a user-input,
is converted to a moisture source using
the model
<a href=\"modelica://Buildings.Rooms.BaseClasses.HeatGain\">
Buildings.Rooms.BaseClasses.HeatGain</a>.
</li>
<li>
The radiant heat gains in the infrared spectrum are also a user
input. They are distributed to the room enclosing surfaces using
the model
<a href=\"modelica://Buildings.Rooms.BaseClasses.InfraredRadiationGainDistribution\">
Buildings.Rooms.BaseClasses.InfraredRadiationGainDistribution</a>.
</li>
<li>
The infrared radiative heat exchange between the room enclosing
surfaces is modeled in
<a href=\"modelica://Buildings.Rooms.BaseClasses.InfraredRadiationExchange\">
Buildings.Rooms.BaseClasses.InfraredRadiationExchange</a>.
This model takes into account the absorptivity of the surfaces and
the surface area. However, the view factors are assumed to be 
proportional to the area of the receiving surface, without taking
into account the location of the surfaces.
</li>
<li>
The solar radiation exchange is modeled in
<a href=\"modelica://Buildings.Rooms.BaseClasses.SolarRadiationExchange\">
Buildings.Rooms.BaseClasses.SolarRadiationExchange</a>.
The assumptions in this model is that all solar radiation
first hits the floor, and is then partially absorbed and partially reflected by the floor.
The reflectance are diffuse, and the reflected radiation is distributed
in proportion to the product of the receiving areas times their
solar absorptivity.
</li>
</ol>
</li>
</ol>
<h4>Model instantiation</h4>
<p>The next paragraphs describe how to instantiate a room model.
To instantiate a room model, 
<ol>
<li>
make an instance of the room model in your model,
</li>
<li>
make instances of constructions from the package 
<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueConstructions\">
Buildings.HeatTransfer.Data.OpaqueConstructions</a> to model opaque constructions such as walls, floors,
ceilings and roofs,
</li>
<li>
make an instance of constructions from the package 
<a href=\"modelica://Buildings.HeatTransfer.Data.GlazingSystems\">
Buildings.HeatTransfer.Data.GlazingSystems</a> to model glazing systems, and
</li>
<li>
enter the parameters of the room. 
</li>
</ol>
<p>
Entering parameters may be easiest in a textual editor. 
</p>
<p>
In the here presented example, we assume we made several instances
of data records for the construction material by dragging them from 
the package <a href=\"modelica://Buildings.HeatTransfer.Data\">
Buildings.HeatTransfer.Data</a> to create the following list of declarations:
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    matLayExt </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Construction material for exterior walls\"</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{-60,140},{-40,160}})));</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120</span><span style=\" font-family:'Courier New,courier';\"> matLayPar </span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier'; color:#006400;\">    \"Construction material for partition walls\"</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{-20,140},{0,160}})));</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.OpaqueConstructions.Generic</span><span style=\" font-family:'Courier New,courier';\"> matLayRoo(</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">        material={</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">          </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">HeatTransfer.Data.Solids.InsulationBoard</span><span style=\" font-family:'Courier New,courier';\">(x=0.2),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">          </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">HeatTransfer.Data.Solids.Concrete</span><span style=\" font-family:'Courier New,courier';\">(x=0.2)},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">        </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">final </span><span style=\" font-family:'Courier New,courier';\">nLay=2) </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Construction material for roof\"</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{20,140},{40,160}})));</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.OpaqueConstructions.Generic</span><span style=\" font-family:'Courier New,courier';\"> matLayFlo(</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">        material={</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">          </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">HeatTransfer.Data.Solids.Concrete</span><span style=\" font-family:'Courier New,courier';\">(x=0.2),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">          </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">HeatTransfer.Data.Solids.InsulationBoard</span><span style=\" font-family:'Courier New,courier';\">(x=0.1),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#000000;\">      </span><span style=\" font-family:'Courier New,courier';\">HeatTransfer.Data.Solids.Concrete(x=0.05)</span><span style=\" font-family:'Courier New,courier'; color:#000000;\">}</span><span style=\" font-family:'Courier New,courier';\">,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">        </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">final </span><span style=\" font-family:'Courier New,courier';\">nLay=3) </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Construction material for floor\"</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{60,140},{80,160}})));</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear</span><span style=\" font-family:'Courier New,courier';\"> glaSys(</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    UFra=2,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    shade=</span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.Shades.Gray</span><span style=\" font-family:'Courier New,courier';\">(),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    haveExteriorShade=false,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    haveInteriorShade=true) </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Data record for the glazing system\"</span></span>
<span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{100,140},{120,160}})));</span>

</pre>
<p>
Note that construction layers are assembled from the outside to the room-side. Thus, the construction
<code>matLayRoo</code> has an exterior insulation. This constructions can then be used in the room model.
</p>
<p>
Before we explain how to declare and parametrize a room model, 
we explain the different models that can be used to compute heat transfer through the room enclosing surfaces
and constructions. The room model 
<a href=\"modelica://Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a> contains the constructions shown
in the table below. 
The first row of the table lists the name of the data record that is used by the user
to assign the model parameters. 
The second row lists the name of the instance of the model that simulates the equations.
The third column provides a reference to the class definition that implements the equations.
The forth column describes the main applicability of the model.
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th>Record name</th>
<th>Model instance name</th>
<th>Class name</th>
<th>Description of the model</th></tr>
<tr>
<td>
<a href=\"modelica://Buildings.Rooms.BaseClasses.ParameterConstruction\">
datConExt</a>
</td>
<td>
modConExt
</td>
<td>
<a href=\"modelica://Buildings.Rooms.Constructions.Construction\">Buildings.Rooms.Constructions.Construction</a>
</td>
<td>
Exterior constructions that have no window.
</td>
</tr>
<tr>
<td>
<a href=\"modelica://Buildings.Rooms.BaseClasses.ParameterConstructionWithWindow\">
datConExtWin</a>
</td>
<td>
modConExtWin
</td>
<td>
<a href=\"modelica://Buildings.Rooms.Constructions.ConstructionWithWindow\">Buildings.Rooms.Constructions.ConstructionWithWindow</a>
</td>
<td>
Exterior constructions that have a window. Each construction of this type must have one window.
<br/>
Within the same room, all windows can either have an interior shade, an exterior shade or no shade.
Each window has its own control signal for the shade. This signal is exposed by the port <code>uSha</code>, which
has the same dimension as the number of windows. The values for <code>uSha</code> must be between 
<code>0</code> and <code>1</code>. Set <code>uSha=0</code> to open the shade, and <code>uSha=1</code>
to close the shade.<br/>
Windows can also have an overhang, side fins, both (overhang and sidefins) or no external shading device.
</td>
</tr>
<tr>
<td>
<a href=\"modelica://Buildings.Rooms.BaseClasses.ParameterConstruction\">
datConPar</a>
</td>
<td>
modConPar
</td>
<td>
<a href=\"modelica://Buildings.Rooms.Constructions.Construction\">Buildings.Rooms.Constructions.Construction</a>
</td>
<td>
Interior constructions such as partitions within a room. Both surfaces of this construction are inside the room model
and participate in the infrared and solar radiation balance. 
Since the view factor between these surfaces is zero, there is no infrared radiation from one surface to the other
of the same construction.
</td>
</tr>
<tr>
<td>
<a href=\"modelica://Buildings.Rooms.BaseClasses.ParameterConstruction\">
datConBou</a>
</td>
<td>
modConBou
</td>
<td>
<a href=\"modelica://Buildings.Rooms.Constructions.Construction\">Buildings.Rooms.Constructions.Construction</a>
</td>
<td>
Constructions that expose the other boundary conditions of the other surface to the outside of this room model.
The heat conduction through these constructions is modeled in this room model. 
The surface at the port <code>opa_b</code> is connected to the models for convection, infrared and solar radiation exchange 
with this room model and with the other surfaces of this room model.
The surface at the port <code>opa_a</code> is connected to the port <code>surf_conBou</code> of this room model. This could be used, for example,
to model a floor inside this room and connect to other side of this floor model to a model that computes heat transfer in the soil.
</td>
</tr>
<tr>
<td>
<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic\">
surBou</a>
</td>
<td>
N/A
</td>
<td>
<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic\">Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic</a>
</td>
<td>
Opaque surfaces of this room model whose heat transfer through the construction is modeled outside of this room model.
This object is modeled using a data record that contains the area, solar and infrared emissivities and surface tilt.
The surface then participates in the convection and radiation heat balance of the room model. The heat flow rate and temperature
of this surface are exposed at the heat port <code>surf_surBou</code>.
An application of this object may be to connect the port <code>surf_surBou</code> of this room model with the port
<code>surf_conBou</code> of another room model in order to couple two room models.
Another application would be to model a radiant ceiling outside of this room model, and connect its surface to the port
<code>surf_conBou</code> in order for the radiant ceiling model to participate in the heat balance of this room.
</td>
</tr>
</table>
<p>
With these constructions, we may define a room as follows: </p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.Rooms.MixedAir</span><span style=\" font-family:'Courier New,courier';\"> roo(</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">redeclare package</span><span style=\" font-family:'Courier New,courier';\"> Medium = </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">MediumA</span><span style=\" font-family:'Courier New,courier';\">,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    AFlo=6*4,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    hRoo=2.7,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConExt=2,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConExt(layers={matLayRoo, matLayExt},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           A={6*4, 6*3},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           til={Buildings.HeatTransfer.Types.Tilt.Ceiling, Buildings.HeatTransfer.Types.Tilt.Wall},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           azi={Buildings.HeatTransfer.Types.Azimuth.S, Buildings.HeatTransfer.Types.Azimuth.W}),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConExtWin=nConExtWin,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConExtWin(layers={matLayExt}, A={4*3},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              glaSys={glaSys},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              hWin={2},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              wWin={2},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              fFra={0.1},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              til={Buildings.HeatTransfer.Types.Tilt.Wall},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              azi={Buildings.HeatTransfer.Types.Azimuth.S}),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConPar=1,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConPar(layers={matLayPar}, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=10,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Buildings.HeatTransfer.Types.Tilt.Wall),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConBou=1,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConBou(layers={matLayFlo}, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=6*4,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Buildings.HeatTransfer.Types.Tilt.Floor),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nSurBou=1,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    surBou(</span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=6*3, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">absIR=0.9, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">absSol=0.9, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Buildings.HeatTransfer.Types.Tilt.Wall),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    linearizeRadiation = true ,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    lat=0.73268921998722) </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Room model\"</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{46,20},{86,60}})));</span></span>

</pre>
<p>
The following paragraphs explain the different declarations.
</p>
<p>
The statement
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">redeclare package</span><span style=\" font-family:'Courier New,courier';\"> Medium = </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">MediumA</span><span style=\" font-family:'Courier New,courier';\">,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    AFlo=20,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    V=20*2.5,</span></span>

</pre>
<p>
declares that the medium of the room air is set to <code>MediumA</code>, 
that the floor area is <i>20 m<sup>2</sup></i> and that 
the room air volume is <i>20*2.5 m<sup>3</sup></i>. 
The floor area is used to scale the internal heat
gains, which are declared with units of <i>W/m<sup>2</sup></i> 
using the input signal <code>qGai_flow</code>.
</p>
<p>
The next entries specify constructions and surfaces
that participate in the heat exchange.
</p>
<p>
The entry
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConExt=2,</span></span>
</pre>
<p>
declares that there are two exterior constructions.
</p>
<p>
The lines 
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConExt(layers={matLayRoo, matLayExt},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           A={6*4, 6*3},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           til={Buildings.HeatTransfer.Types.Tilt.Ceiling, Buildings.HeatTransfer.Types.Tilt.Wall},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           azi={Buildings.HeatTransfer.Types.Azimuth.S, Buildings.HeatTransfer.Types.Azimuth.W}),</span></span>

</pre>
<p>
declare that the material layers" + " in these constructions are
set the the records <code>matLayRoo</code> and <code>matLayExt</code>.
What follows are the declarations for the surface area,
the tilt of the surface and the azimuth of the surfaces. Thus, the 
surface with construction <code>matLayExt</code> is <i>6*3 m<sup>2</sup></i> large
and it is a west-facing wall.
</p>
<p>
Next, the declaration
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConExtWin=nConExtWin,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConExtWin(layers={matLayExt}, A={4*3},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              glaSys={glaSys},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              hWin={2},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              wWin={2},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0p; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              fFra={0.1},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              til={Buildings.HeatTransfer.Types.Tilt.Wall},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              azi={Buildings.HeatTransfer.Types.Azimuth.S}),</span></span>
</pre>
<p>
declares the construction that contains a window. This construction is built
using the materials defined in the record <code>matLayExt</code>. Its total area,
including the window, is <i>4*3 m<sup>2</sup></i>.
The glazing system is built using the construction defined in the record
<code>glaSys</code>. The window area is <i>h<sub>win</sub>=2 m</i> high
and
<i>w<sub>win</sub>=2 m</i> wide.
The ratio of frame
to total glazing system area is <i>10%</i>.
</p>
<p>
Optionally, each window can have an overhang, side fins or both.
If the above window were to have an overhang of
<i>2.5 m</i> width that is centered above the window, 
and hence extends each side of the window by <i>0.25 m</i>, and has a depth of
<i>1 m</i> and a gap between window and overhang of 
<i>0.1 m</i>, then
its declaration would be
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              ove(wL={0.25}, wR={0.25}, gap={0.1}, dep={1}),</span></span>
</pre>
<p>
This line can be placed below the declaration of <code>wWin</code>.
This would instanciate the model
<a href=\"modelica://Buildings.HeatTransfer.Windows.Overhang\">
Buildings.HeatTransfer.Windows.Overhang</a> to model the overhang. See this class for a picture of the above dimensions.
</p>
<p>
If the window were to have side fins that are 
<i>2.5 m</i> high, measured from the bottom of the windows,
and hence extends <i>0.5 m</i> above the window, are
<i>1 m</i> depth and are placed 
<i>0.1 m</i> to the left and right of the window,
then its declaration would be
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              sidFin(h={0.5}, gap={0.1}, dep={1}),</span></span>
</pre>
<p>
This would instanciate the model
<a href=\"modelica://Buildings.HeatTransfer.Windows.SideFins\">
Buildings.HeatTransfer.Windows.SideFins</a> to model the side fins. See this class for a picture of the above dimensions.
</p>
<p>
The lines
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              til={Buildings.HeatTransfer.Types.Tilt.Wall},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              azi={Buildings.HeatTransfer.Types.Azimuth.S}),</span></span>
</pre>
<p>
declare that the construction is a wall that is south exposed.
</p>
<p>
Note that if the room were to have two windows, and one window has side fins and the other window has an overhang, the 
following declaration could be used, which sets the value of <code>dep</code> to <code>0</code> for the non-present side fins or overhang, respectively:
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              sidFin(h  = {0.5, 0}, gap = {0.1, 0.0}, dep = {1, 0}),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              ove(wL = {0.0, 0.25}, wR = {0.0, 0.25}, gap = {0.0, 0.1}, dep = {0, 1}),</span></span>
</pre>
<p>
What follows is the declaration of the partition constructions, as declared by
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConPar=1,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConPar(layers={matLayPar}, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=10,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Buildings.HeatTransfer.Types.Tilt.Wall),</span></span>

</pre>
<p>
Thus, there is one partition construction. Its area is <i>10 m<sup>2</sup></i> for <em>each</em>
surface, to form a total surface area inside this thermal zone of <i>20 m<sup>2</sup></i>.
</p>
<p>
Next, the declaration
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConBou=1,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConBou(layers={matLayFlo}, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=6*4,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Buildings.HeatTransfer.Types.Tilt.Floor),</span></span>

</pre>
<p>
declares one construction whose other surface boundary condition is exposed by this
room model (through the connector <code>surf_conBou</code>).
</p>
<p>
The declaration
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nSurBou=1,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    surBou(</span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=6*3, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">absIR=0.9, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">absSol=0.9, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Buildings.HeatTransfer.Types.Tilt.Wall),</span></span>

</pre>
<p>
is used to instantiate a model for a surface that is in this room. 
The surface has an area of <i>6*3 m<sup>2</sup></i>, absorptivity in the infrared and the solar
spectrum of <i>0.9</i> and it is a wall.
The room model will compute infrared radiative heat exchange, solar radiative heat gains
and infrared radiative heat gains of this surface. The surface temperature and 
heat flow rate are exposed by this room model at the heat port 
<code>surf_surBou</code>. 
A model builder may use this construct
to couple this room model to another room model that may model the construction.
</p>
<p>
The declaration
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    linearizeRadiation = true,</span></span>

</pre>
<p>
causes the equations for radiative heat transfer to be linearized. This can
reduce computing time at the expense of accuracy.
</p>
<p>
The declaration 
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,</span></span>

</pre>
<p>
is used to initialize the air volume inside the thermal zone.
</p>
<p>
Finally, the declaration
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    lat=0.73268921998722) </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Room model\"</span></span>

</pre>
<p>
sets the latitude of the building which needs to correspond with the latitude of the weather data file.
</p>
<h4>References</h4>
<p>
<a NAME=\"WetterEtAl2011\"/> 
Michael Wetter, Wangda Zuo and Thierry Stephane Nouidui.<br/>
<a href=\"modelica://Buildings/Resources/Images/Rooms/2011-ibpsa-BuildingsLib.pdf\">
Modeling of Heat Transfer in Rooms in the Modelica \"Buildings\" Library.</a><br/>
Proc. of the 12th IBPSA Conference, p. 1096-1103. Sydney, Australia, November 2011. 
</p>
</html>"));
  end MixedAir;

  class FFD "Room model with air heat and mass balance computed using Fast Fluid Dynamics"
    extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The model <a href=\"modelica://Buildings.Rooms.FFD\">Buildings.Rooms.FFD</a> is 
a room model in which the room air heat and mass balance is computed
using the Fast Fluid Dynamics algorithm.
</p>
<p>
fixme: add description
</p>
<h4>Implementation</h4>
<p>
fixme.
</p>
</html>"));
  end FFD;

end UsersGuide;
