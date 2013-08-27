within Buildings.Rooms.FLEXLAB;
package Rooms "Models of individual rooms in FLEXLAB test beds"
extends Modelica.Icons.Package;



  annotation(Documentation(info="<html>
    <p>
    This package contains models of rooms found in the FLEXLAB test beds.
    </p>
    <p>
    All FLEXLAB room models are created by extending the <a href=\"modelica:Buildings.Rooms.MixedAir\">
    Buildings.Rooms.MixedAir</a> model. This model contains several ports which must be used to describe
    the heat transfer into and our of the space. The ports are described both here and in the documentation
    for <a href=\"modelica:Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a>. For a description of the
    ports, see the following table:
    </p>
    <table border = \"1\" summary=\"Description of ports in FLEXLAB models\">
    <tr>
    <th>Name in image</th>
    <th>Connection port name</th>
    <th>Physical significance</th>
    </tr>
    <tr>
    <td>u</td>
    <td>qGai_flow</td>
    <td>Shade control signal.<br/>
     1 = closed shade<br/>
     0 = open shade</td>
    </tr>
    <tr>
    <td>q</td>
    <td>qGai_flow</td>
    <td>Internal gains matrix<br/>
    [1] = Radiant<br/>
    [2] = Convective<br/>
    [3] = Latent</td>
    </tr>
    <tr>
    <td>surface</td>
    <td>surf_surBou</td>
    <td>Models walls of the room with the construction represented externally. The connection represents heat
    transfer from the surface (represented by a separate model outside of the room model) to the air in the space.
    The air in the space must be described within the room model. An example of this could be a description of the
    floor area within the room model, connected to a model of a radiant slab modeled outside the room model</td>
    </tr>
    <tr>
    <td>boundary</td>
    <td>surf_conBou</td>
    <td>Connects to rooms with a shared wall. The wall is modeled in this room, and connects to the air in the other
    room. The area of the air gap in the other room must be described in the other model.</td>
    </tr>
    <tr>
    <td>air</td>
    <td>heaPorAir</td>
    <td>Heat port connecting directly to the air in the room</td>
    </tr>
    <tr>
    <td>radiation</td>
    <td>heaPorRad</td>
    <td>Heat port for radiative heat gain and radiative temperature</td>
    </tr>
    <tr>
    <td></td>
    <td>ports</td>
    <td>Fluid ports representing air flow in the space. Typically used for ventilation and conditioning air.
    Connections must include both an inlet and outlet port.</td>
    </tr>
    </table>
    <p>
    For an example demonstrating how many of these ports are used see 
    <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.Examples.UF90X3AWithRadiantFloor\">
    Buildings.Rooms.FLEXLAB.Rooms.Examples.UF90X3AWithRadiantFloor</a>.
    </p>
    </html>"));

end Rooms;
