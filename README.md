---
author:
- '[Tobias Ludwig]{}'
bibliography:
- 'refs3.bib'
title: |
    [SCAM]{}\
    [**S**ystem**C** **A**bstract **M**odel]{}
---

Introduction {#sec:introduction}
============

In this manual a new hardware design methodology, called
*Property-Driven Design* (PDD) is introduced, which borrows ideas from a
software design paradigm called *Test-Driven Development* (TDD). The
core idea of TDD is that the tests should guide the software engineer
through the design process with the result being that any implemented
code is covered by a test. The flow for designing a new feature with TDD
is:

1.  Create tests that describe the behaviour of the feature.

2.  Choose a test and implement code that fulfills the test.

3.  Check if all previously checked tests are still valid.

4.  Return to 2 until all tests hold on the design.

The software design process is finished if all test hold for the design.
This approach allows an incremental software design process and results
in less design-bugs, a complete test coverage and a documentation of the
code.

[L]{}[0.3]{}

![image](fig/drawing.pdf){width="30.00000%"}

The PDD flow starts with a verified description of the component to
develop at the *Electronic System Level* (ESL). From this description
the tests, in the form of IPC properties (e.g., SVA, ITL), are generated
automatically by our tool *SCAM* (“**S**ystem**C** **A**bstract
**M**odel”). Now, the hardware designer implements the hardware, as in
TDD, by choosing a property and implementing the hardware that fullfills
the property. Once all properties hold on the design the hardware design
process is finished.

The design entry point of the PDD is the ESL and the flow consist of
three major steps. Figure \[fig:PDD-overview\] shows an overview of the
desired flow. The first step is analysing the model with *SCAM* and
refactoring it according to the provided feedback. The resulting SystemC
model is now considered the golden reference for the subsequent steps.
The second step is the generation of the properties from this SystemC
model with *SCAM*. Lastly, the hardware is implemented by iteratively
implementing the hardware property by property. An iteration step
involves implementing the hardware, refining the properties and proving
the properties with a property checker (e.g., OneSpin, Questa).

One novelty of PDD is that the generated properties ensure that the RTL
design to develop has the same I/O behavior as the ESL design. Thereby,
the ESL is a sound abstraction of the RTL design. This enables using the
ESL design as the golden reference and thus verification results from
the system level translate to RTL. Also, any design bug from the system
level will translate to the RTL. This is why we emphasize exhaustive
system-level verification before starting the RTL design process.

Before we start to explain the PDD in more detail you are provided with
a Walk-through in Section \[sec:walk-through\], which explains the steps
of the PDD for a simple example. The *installation* of our tool is
explained in Section \[sec:installation\].

Walk-Through {#sec:walk-through}
============

Step 1: ESL analysis und refactoring {#sec:walk-through-step1}
------------------------------------

The PDD-methdology starts with a system-level design, that acts as
golden reference for the following design process. Here, SystemC is used
as system-level design entry language and a system is defined as a set
of communication modules. On system level the main focus is on
describing and verifying the communication between the modules.

Listing \[lst:walk-through\] shows the description of such a module. The
code shows a SystemC module, named *Example*, with one input and one
output. The inputs and outputs are connected with other modules via
channels. The inputs ( *b\_in* ) and outputs ( *b\_out* ) of the module
use a *blocking* interface. Blocking in this context means, that
underlying communication protocol is that of a four-phase handshake and
the message is transmitted if and only if both sides are ready for
communication.

    struct Example: public sc_module{
      //Constructor
      Example(sc_module_name name):
              value(9){SC_THREAD(fsm);}
      SC_HAS_PROCESS(Example);

      //Ports
      blocking_in<int> b_in;
      blocking_out<bool> b_out;

      //Variabless
      int value;

      //FSM
      void fsm(){
      while(true){
      	b_in->read(value);
      	if(value > 10){
      		b_out->write(true);
      	}else b_out->write(false);
      }}
    };

The behaviour of the module is described within the method *fsm*, that
is registered as a thread to SystemC scheduler and is executed
infinitely often. The module reads a value from the input *b\_in* and
stores the result in the variable *value*. If *value* is $>$10 the
output port sends *true*, *false* otherwise.

In order to describe the modules the designer is not allowed to use an
arbitrary SystemC description. The reason is that not everything that is
possible with SystemC is transferable to hardware, e.g., dynamic memory
allocation. This is why the designer is restricted to a subset called
SystemC-PPA. Thus, after verifying the behaviour of the SystemC module,
the designer has to check whether any constrains of subset are violated
by invoking SCAM with *./SCAM path-to-file -AML*. The following example
shows the output of SCAM without any erros:

    ############################
    Module: Example
    ############################

    ======================
    PPA generation:
    ----------------------
    [...] Metrics of PPA generation

    ======================
    Instances
    ----------------------
    [...] Connection between modules
    [...] No connections for single modules

    ======================
    AML: Example
    ----------------------
    [...] Pseudo-representation of the module

The pseudo-code underneath *“AML: Example”* shows an abstract
representation of the module. The language used here is called
*“Abstract Model Language”* and is based on the specification described
in [@2015-UrdahlStoffel.etal]. A parser for this language is available,
too.

The file *WalkThrough\_with\_error.h* contains a stmt that is not part
of the subset and the output of *SCAM* reports the error. If a statement
is found to be not part of the subset it is ignored for the abstract
model.

    ======================
    Errors: Translation of Stmts for module Example
    ----------------------
    - test.push_back(value)
    	-E- push_back() is not a supported method!

Using a std::vector on system level is beneficial when it comes to
executing the simulation on the COU but it’s not transferable to a
hardware system, because memory implementations have a static and known
size. Thus, the statement is reported by SCAM as not being part of the
subset. The designer has now to decide:  The statement is important for
the module behaviour, in this case the SystemC description has to be
adapted or the statement has no effect on the behaviour (e.g., a
std::cout) and thus the error may be ignored.

Step 2: Property generation {#sec:walk-through-step2}
---------------------------

The second step is generate the propties with our tool *SCAM*. The input
to the tool is a single SystemC module or a system of SystemC modules.
The tool parses the files generates an abstract model, that is used for
the generation of the properties. In order to generate the properties
run *./SCAM path-to-file/WalkThrough.h -ITL*. The *-ITL* command invokes
the ITL-property generation.

    ======================
    ITL: Example
    ----------------------
    State-map(unoptimized):8 operations created
    State-map(optimized):8 operations created
    ----------------------
    [...]

Here, we will provide a quick overview over the generated abstract
properties, for more details we refer to following sections. In order to
link the abstract objects of the system-level to a concrete RTL
implementation we introduce macros. The RT designer replaces the
*MACRO\_BODY* with concrete information from the RT design. For *b\_in*
and *b\_out* the following macros are generated:

    -- SYNC AND NOTIFY SIGNALS
    macro b_in_notify :boolean:= MACRO_BODY end macro; 
    macro b_in_sync   :boolean:= MACRO_BODY end macro; 
    macro b_out_notify:boolean:= MACRO_BODY end macro; 
    macro b_out_sync  :boolean:= MACRO_BODY end macro; 
    -- DP SIGNALS -- 
    macro b_in_sig : int := %BODY% end macro; 
    macro b_out_sig : bool := %BODY% end macro; 

The sync and notify signals are of type boolean and are necessary for
implementing the four-phase handshake and the actual message is
specified as datapath macro.

The notify signals evaluates to true, if the module is ready for
communication and the sync signal evaluates to true if the corresponding
communication partner is ready. If both sides are ready for
communication the message is exchanged.

The most important step is refining the abstract representation of the
system-level behaviour of the module. In our methodology the generated
properties capture the I/O behaviour of the system-level design. The
system-level thread transformed into a FSM, with states beeing the
comunication points and transitions between states formalized as
properties.

Listing \[lst:walk-through\] contains three communication calls
(line 17, 19, 20). For each of those points a state is introduced, the
states are called important states because they represent important
control points of the hardware. The hardware design has to specify which
hardware state represents this important state. In order to do so it’s
allowed to use internal signals as well as outputs.

    -- STATES -- 
    macro run_0 : boolean :=  end macro;
    macro run_1 : boolean :=  end macro;
    macro run_2 : boolean :=  end macro;

The properties describing the transition between important states are
written as IPC properties. Each property starts and ends in an important
state and there is a property for each possible execution path between
two states. The following property starts in the important state
*run\_0*, that is the state after reset and in this state the design
waits for a new input and describes the path for $b\_in\_sig \geq 11 $.
If the input is available ($b\_in\_sync == true$ ) and the input value
is greater then 10 the hardware transitions to important state *run\_1*.
In *run\_1* the value of *b\_out\_sig* is set to true and the
counterpart is notified by raising *b\_out\_notify*. The hardware
remains in state *run\_1* until the counterpart accepts the handshake
and the message is passed.

    property run_0_read_0 is
    dependencies: no_reset;
    for timepoints:
      t_end = t+1; -- CHANGE HERE
    assume: 
      at t: run_0;
      at t: (b_in_sig >= 11);
      at t: b_in_sync;
    prove:
      at t_end: run_1;
      at t_end: b_out_sig=true;
      during[t+1,t_end]: b_in_notify=false;
      during[t+1,t_end-1]: b_out_notify=false;
      at t_end: b_out_notify = true;
    end property;

In case the module has to wait for the communication partner a
wait-property is generated automatically for each blocking
communication, that enforces the hardware to remain in the same
important state until the respective *sync* signal is active.

Step 3: Hardware implementation {#sec:walk-through-step3}
-------------------------------

The RT-designer has the task to specify how the abstract datapath signal
is implemented by the RT-design by filling out the macros. For example,
the macro *b\_in\_sig* represents the incoming value. The designer has
an infinite amount of possibilities for filling this macro. The incoming
message may be transported by the input signal value\_in and thus the
macro is refined into

    macro b_in_sig : int := 
      RT_design/value_in 
    end macro; 

It is also possible that message is transported by two different RT
signals and the resulting value is the sum of those two signals. The
designer provides this information in the macro body.

    macro b_in_sig : int := 
      RT_design/input1 + RT_design/input2  
    end macro; 

In case there exist no previous implementation the RT-designer has the
option to generate a VHDL-template by running *./SCAM
path-to-file/WalkThrough.h -VHDL*. This template contains a package with
all used datatypes and a barbone VHDL implementation matching the
properties. The template is not a synthesized design and thus doesn’t
contain any behavioural components. In order to get a full list of
available commands run *SCAM* without parameters.

In order to start the hardware design process, load your VHDL template
or empty design and the accompanying properties with the property
checker. The first property to prove is the reset property. The design
process continues with implementing all operations starting in the
important state after reset. The HW-designer has also the task to refine
the abstract state macros during the design process.

System level and SystemC-PPA {#sec:system-level}
============================

The design flow starts at the Electronic System Level (ESL) and the
abstract model is described as an executable system model, that is
composed of communicating modules. Communication is modelled on the
transaction level and the behavior of the modules is described as an
untimed, bit-abstract model. Each module is modelled as a path predicate
abstraction
(PPA)[@2015-UrdahlStoffel.etal][@2014-UrdahlStoffel.etal][@2016-UrdahlUdupi.etal]
which describes the behavior as a FSM in terms of its I/O states and
transitions. The behavior of the system level results from the
asynchronous product of the module’s behavior.

Due to the untimed behavior of the system, each module may run at a
different speed. In order to exchange a message between two modules they
need to synchronize through a handshake, which ensures that a message is
not lost during transaction. At system level this handshake is
implemented through events, during the HW-design process the handshake
is realized by a four-phase handshake.

Sometimes the full handshaking bears unnecessary overhead, e.g., the
designer accepts that a message may be lost. This is why we introduced
three different interfaces for the ports that provide, in our
experience, enough flexibility to describe any desired hardware
behavior. It’s the system designer task to choose the communication
scheme of a port during the system-design process.

Each interface will generate a different kind of property suite and
thereby affects the hardware design process. The basic interface is
called *blocking* and it implements the blocking-message passing
handshake, it ensures that a message is never lost. *MasterSlave* is a
special case of the blocking interface for synchronous communication, if
it is known that one side is always ready for communication the other
side may communicate without waiting for synchronization. The *Shared*
interface models the behavior of a volatile memory.

In order simulate and verify the system-level design an executable
description of the system is required. The industry standard for
executable system level designs is SystemC, but the semantics of SystemC
do not match the semantics of our formal model perfectly. SystemC, as
well as many other high-level modeling languages employed in the
industry, are primarily software programming languages. For example,
SystemC is used by a framework of class hierarchies and macro
definitions to describe the structure of hardware systems, with the
associated behavior being modeled in C++. While C++ has clearly defined
semantics as a programming language, the high-level objects defined in
the SystemC class framework lack a precise semantics with respect to the
abstract hardware designs they are intended for. We solved this by
restricting SystemC to a subset of certain constructs called
SystemC-PPA.

The following example provides an idea on the semantic understanding of
the system-level model for blocking message passing. Assume the
component to design is a CPU, most designers will describe a CPU as a
set of modules e.g., ALU, RegisterFile, Control Unit., which are
connected to each other via ports. For example, the *Control Unit* has
an output port next\_instruction and the *ALU* has an input
next\_instruction. The *Control Unit* sends a new instruction formalized
as a message (e.g. ADD rs1,rs2,rd) to the *ALU*. If the *ALU* is still
busy with a different instruction the *Control Unit* is blocked until
the *ALU* is ready for the next instruction. The blocking message
passing handshake is also referenced as *rendez-vouz communication*.
(Rendez-vouz communication is an analogy: In order for two people to
communicate they have to be at the same place at the same time. If
either one is missing the other one has to wait.)

Modules
-------

Listing \[lst:Example-SystemC\] shows the code of a SystemC module. It’s
composed of the constructor, ports, variables and the method containing
the behavior named FSM. Those constructs are sufficient to describe any
abstract hardware model. Every C++ construct which is not mentioned
here, is not part of the subset and will be detected as unknown by the
tool.

In the following sections each element is discussed in more detail.

    struct Example: public sc_module{
      //Constructor
      Example(sc_module_name name):
        var(9){SC_THREAD(fsm);}
      SC_HAS_PROCESS(FPI_Master);
      
      //Ports
      blocking_in<int> b_in;
      shared_out<bool> s_out;
      
      //Variabless
      int value;

      //FSM
      void fsm();
    }

The user is also free to use the standard macros that are provided with
SystemC. The compiler replaces those macros what results in the code
shown above.

    SC_MODULE(Example){
      //Constructor
      SC_CTOR(Example):
        var(9){SC_THREAD(fsm);}
      [...]
    }

Variables and Datatypes
-----------------------

Variables are defined within the class definition. The initial value is
set within the constructors initialization list. Every variable defined
as a property within the class will be added to the abstract model as a
variable. Variables are only allowed to be declared within the class
definition.

The only allowed built-in datatypes are *bool*, *int* and *unsigned
int*. Line 12 in Listing \[lst:Example-SystemC\] shows the declaration
of an integer variable called *value*. The designer is also allowed to
use enums or define it’s own datatypes. The enum has to be defined
within the scope of the module as shown in Listing \[lst:variables\] on
line 2. Line 9 shows the declaration of an enum variable. Custom
datatypes are declared as a struct with no constructor and no methods as
shown in line 4. They are called *compound datatypes*, because they are
composed out of a set of built-in datatypes and enums. For example,
*Msg\_type* defines a compound with three subvariables *addr*, *data*
and *mode*. Until now, there is no possibility to assign an initial
value to the subvariables. Hence, they are initialized with the default
value of the datatype. The custom datatypes are added to the abstract
model as datatypes.

    //Enum Datatype 
    enum Transfer_mode{read,write};
    //Compound Datatype
    struct Msg_type{int addr; int data; Transfer_mode mode;}
    //Module
    struct Example: public sc_module{
      [...]
      //Variables
      Transfer_mode trans_mode;
      Msg_type message;
      //FSM
      [...]
    }

Constructor {#section:constructor}
-----------

Constructors in C++ allow a large degree of freedom. For describing
abstract hardware models, the constructor shown in
Listing \[lst:constructor\] is sufficient. Only the constructors
initialization list is used for variable initialization. The constructor
body is not taken into consideration.

    struct Example: public sc_module{
      //Constructor
      Example(sc_module_name name):
        port("port"),
        var(9){SC_THREAD(fsm);}
      SC_HAS_PROCESS(Example);
      [...]
    }

The SystemC macro SC\_THREAD(fsm) registers the method fsm as a thread
and the macro SC\_HAS\_PROCESS(Example) makes the module visible to the
SystemC Scheduler. This functionality is purely SystemC specific and has
no meaning for the abstract model. Each port of the module has to be
initialized within the constructor as shown in line 4 for *port*.

Ports {#section:ports}
-----

Listing \[lst:ports\] shows all allowed port types. For example, line 4
shows the declaration of a blocking input port that receives a message
of type integer. A port declaration always follows the structure
*“interface\_direction $<$message\_type$>$ name;”*. Possible interfaces
are *blocking*, *shared*, *slave* and *master*, all of which implement a
different blocking mechanism. Allowed directions are *in* for receiving
and *out* for sending a message. As message type all previously defined
custom types and built-in types are allowed. The interface defines how
the communication is modelled on the RTL, hence they play a crucial role
in the methodology. More detailed discussion follows in
Section \[section:interfaces\].

    struct Example: public sc_module{
      [...]
      //Blocking interface
      blocking_in<int> blocking_in;
      blocking_out<int> blocking_out;
      //Shared interface
      shared_in<bool> shared_in;
      shared_out<bool> shared_out;
      //Slave
      slave_in<Msg_type> slave_in;
      slave_out<Msg_type> slave_out;
      //Master
      master_in<Transfer_mode> master_in;
      master_out<Transfer_mode> master_out;
      [...]
    }

The ports are actually sc\_ports with a custom interface. For example
$slave\_in$ is defined as “using
$slave\_in = sc\_port<slave\_in\_if<T> >$” and $slave\_in\_if$ defines
the interface methods for this port. Declaring simple names for the
interfaces facilitates code parsing and opens up the methodology to a
wider audience as less SystemC knowledge is required.

Unfortunately, we couldn’t use any standard SystemC ports, because as
non of them provides pure RendezVouz communication. Initially the idea
was to use an zero-depth sc\_fifo for modeling RendezVouz communication,
but the SystemC standard forbids zero-depth fifos. Furthermore, we
restricted the users ability to use any other ports, because this would
require an analysis of the underlying mechanisms. This has shown to be a
complex tasks and doesn’t support the PDD.

Interfaces {#section:interfaces}
----------

### Blocking

The blocking interface implements the *rendezVouz* communication as
mentioned earlier. In order to send a message, there are two interface
methods $write(value)$ and $nb\_write(value)$. The interface that
implements this behavior is *rendezvous\_in\_if$<$T$>$*. By calling
*port\_name$\rightarrow$write(value)* the sender sends a message with
the specified value. Prior sending it’s checked whether the receiver is
ready to receive a new message. This is achieved with the help of an
internal flag of the interface that stores the status of the receiver.
The sender is blocked until the reader\_notify event is raised by the
receiver.

By calling *port\_name$\rightarrow$nb\_write(value)* the port also sends
the message, but doesn’t block the module. The sender assumes the
receiver to be ready for communication. If the assumption is correct,
the message is passed and $nb\_write(value)$ returns true. Otherwise,
$nb\_write(value)$ returns false and the message is lost. Hence, by
using this interface losing a message is accepted.

[L]{}[0.3]{}

![image](fig/write_vs_nb_write.pdf){width="30.00000%"}

Figure \[fig:write-vs-nb-write\] shows the different wait automatons for
the regular write and the non-blocking write. The boolean
synchronization signal *synch* is *true* if the counterpart is ready for
communication, *false* otherwise. The figure shows the difference in the
blocking behavior of those two modules.

For receiving a message the methods $read(variable)$ and
$nb\_read(variable)$ are used. Upon handshake completion the message
send by the sender is stored in *variable*. The receiving interface
works similar to the write, with one difference for the
$nb\_read(variable)$. If no new message is present the value of variable
remains unchanged.

### Shared

The shared interface offers a method *port\_name$\rightarrow$set(value)*
for sending a message and a method *port\_name$\rightarrow$get(value)*
for retrieving a message. This interface doesn’t implement any
handshaking mechanism and models the behavior of a volatile memory. The
input and output of those ports may change at any timepoint. This
interface is mainly intended for the case, that the system needs to talk
with the environment. For example, if a value from a analog-digital
converter is read, a handshaking mechanism is not necessary because the
value changes continuously and the system reads whatever value is
present at the current timepoint. The same ideas applies for sending
value to a environment device. The shared interface behaves almost the
same as a RT signal.

Because the interface doesn’t implement a handshaking mechanism there is
no wait state necessary for using a shared port. The shared ports become
part of the datapath and are internally treated like variables that are
visible from the outside/inside. Hence, the shared ports are going to
show up in the datapath of the generated properties.

### MasterSlave

This is a special interface that is only allowed to be used on
synchronous chips. The common use-case for this interface is synchronous
communication between two modules. The system-level designer knows that
a message send/received by master can’t be lost because the
corresponding slave is always ready to communicate. This behavior is
enforced by the later generated properties.

    struct Example: public sc_module{
      [...]
      master_in<Transfer_mode> master_in;
      master_out<Transfer_mode> master_out;
      [...]
    }

On system level this interface is modeled similar to the blocking
interface, because we’re only interested in passing the message. The
master is allowed to communicate at any timepoint and it’s ensured that
the slave is always ready. No message from a master to a slave is lost
and there is always a fresh message from a slave to a master. The slave
accepts loosing a message, for example an *slave\_out* port writes a
message at each timepoint and accepts that the master doesn’t receive
it’s message. A *slave\_in* port always tries to receive a message.

There are some restrictions compared to the blocking interface. The
interface is split into two sides, the master side and the slave side.
Each master has to be connected to a slave on system level.

Once a module has a slave port, it’s considered a slave-module and it’s
required that:

-   every slave-port is used within the fsm

-   no slave-port is used twice before every other slave-port is used

-   the order in which the slave ports are used has to remain the same
    for each possible path

-   ports with blocking interface are not allowed for slave modules

The master interface offers *port\_name$\rightarrow$write(value)* method
for sending a message and *port\_name$\rightarrow$read(var)* for reading
a message. There is no nb\_read/nb\_write necessary, because it’s known
that the counterpart is always ready to communicate and thus the return
value evaluates to true.

The slave interface offers *void*
*port\_name$\rightarrow$nb\_write(value)* method for sending a message
and *bool* *port\_name$\rightarrow$nb\_read(value)* for reading a
message. For the slave\_out port the write method doesn’t block,because
loosing the message is accepted and the master is not required to catch
every message. For the slave\_in port a nb\_read method is necessary
because the message should only be captured if the corresponding
master\_out did actually send a message. The return value of nb\_write
is void where nb\_read returns true if there is a new message from a
master.

FSM {#section:FSM}
---

**Basic**

The supported set of SystemC language features allows ESL modeling of
any type of digital hardware. The mentioned modeling restrictions may
forbid the use of certain SystemC constructs, but they warrant the
precise the semantics of the models and they are key to enabling a
sound, top-down refinement, “property-first” design methodology.
Listing \[lst:behavior\] shows the basic structure of the method
describing the behavior. When modeling the behavior, the user needs to
adhere to the code structure shown in the example: There must be a
single function that is registered as the one and only SystemC thread
(cf. line 5) in this module.

The function must contain one outer infinite loop written as *while
(true) { …}* with the body describing the sequencing of sections of
behavior, as shown in the example. This is necessary to precisely define
a finite state control behavior in the form of an FSM. Because a module
only has one possible behavior the user is only allowed to use one
thread for describing the behavior. In order to simulate the blocking
behavior using threads is mandatory, because sc\_process and sc\_method
don’t allow to be blocked.

Hardware does execute forever and thus the behavior is described within
an infinite while(true) loop and at the end of the loop it’s recommended
to have a sc\_zero\_time. This is more a detail that is necessary due to
the scheduler, because the other threats should be able to advance in
their execution, too. The described model should describe untimed
behavior and thus all other notions of time are not allowed.

    struct Example: public sc_module{
      [...]
      //FSM
      void fsm(){
          while(true){
          [...] //Functional description here 
          wait(sc_zero_time);
          }
      };
    }

Listing \[lst:example\_1\] shows a simple behavioral description, that
guides as a simple overview of allowed constructs within our SystemC-AML
subset. In line 4 a message from the input port *blocking\_in* is read
by calling the interface method *read()*, the value of the message is
stored in an integer variable *frames\_ok*.

The execution of the thread is blocked until the counterpart sends a
message, after the message is received execution continues at line 5. If
*frames\_ok* is larger than 10, a success counter is increased by one in
line 6. At line 7 a message is send over the blocking port
*blocking\_out* using the non-blocking interface. The port will offer a
handshake to it’s counterpart. If the counterpart is ready to
communicate, the boolean variable success will evaluate to true and the
message is passed, otherwise success evaluates to false.

The shared output *shared\_out* sets it’s value to true if the
communication was successful. As mentioned in
Section \[section:interfaces\] for the in port connected to
*shared\_out* reading from this port is same as accessing a variable
inside this module and setting the value of this port is the same as
setting the value of a variable. If frames\_ok is less then 10 succ\_cnt
is reset to zero.

[l]{}[.55]{}

    void fsm(){
        while(true){
        //Read blocking port
        blocking_in->read(frames_ok);
        if(framework > 10){
          ++succ_cnt;
          success = blocking_out->write(succ_cnt);
          shared_out->set(success);
        }else succ_cnt=0;
        wait(sc_zero_time);
        }
    };

A full simulation model of this example is provided in doc/Example1/ ,
this also applies for all other examples within this documentation. The
module called Stimuli models the environment of the module Example1. The
modules are connected by the code in sc\_main.cpp. A more detailed view
on the connection is provided in Section \[section:model\]. In order to
build the example follow the standard approach for building CMake
projects.

**Advanced**

The only allowed control structure within the *while(true)*-loop are
if-then-else branches. The use of a for-loops and while-loops is not
allowed, because everything within the behavioral description needs to
be constantly evaluable. In order to generate the properties each path
from a communication to a communication has to be of a finite length.
Using unbounded loops is contrary to this requirement. It’s possible to
relax this requirement to bounded loops, but we provide a different
mechanism for modelling loops, called **sections**.

Sections, are not only used for modelling loops but also for giving the
generated properties a more meaningful name. For the example in
Listing \[lst:example\_1\] all generated properties will have the same
name appended by a unique identification number. We realized that most
designers split the behavior in logical parts. For example a module that
waits for a start signal and then reads a specific amount of messages. A
designer would probably split the behavior in two parts *idle* and
*reading*. Listing \[lst:example\_2\] shows the behavioral description
of such a module. This example also shows how to use compound datatypes.
The declaration of the type is found in Example2/types.h and an example
for accessing the sub-variables is found in Example2/Stimuli.h.

        //Sections
        enum Sections{idle,reading};
        Sections section,nextsection;

        //Behavior
        void fsm() {
            while (true) {
                section = nextsection;
                if(section == idle){
                    block_in->read(start_of_frame);
                    if(start_of_frame) nextsection = reading;
                }
                else if(section == reading) {
                    msg_port->read(msg);
                    ++cnt;
                    if(cnt > 4){
                        nextsection = idle;
                        cnt = 0;
                    }
                }
                wait(SC_ZERO_TIME);
            }
        };

In order to model the idle phase and the reading phase, an enum
“Sections” with two variables of this enum-type are declared in line 2
and 3 and initialized with *idle*. The execution starts at line 8 and
continues with line 10. A message from port *block\_in* is read and the
message is a boolean value. In case a new frame is detected the section
is changed to reading, if not the section idle is executed again. If the
section changes to reading the next statement that is executed is line
14, which receives a new message. Afterwards a counter is increased by
one and this is repeated until the counter is greater than 4, in this
case all the data is received and the module waits for the next
*start\_of\_frame*. Hence, the module changed to section idle and resets
the counter. The next execution of the loop will start with line 10
again.

A while loop is implemented as shown from line 9 to line 12 and a
bounded for-loop Line 13 to Line 20. The designer is free to use custom
enums within the behavioral description to his convenience. If an enum
with name Sections and variables section and nextsection are used, the
tool will recognize this and store this information for later use.
Furthermore, design with many branches are easier to process for the
tool, if sections are used.

**Best practice** for writing modules is to have only one communication
in per section. This allows the tool to process large modules with many
branches easily. Furthermore, the names properties of the properties
that are going to be generated are relying on section the communication
happens. It’s also allowed to have sections without communication, in
this case it’s ensured by the tool that each possible eventually ends at
a communication. If no sections are used the tool adds a default section
*run*.

Model {#section:model}
-----

After describing the functionality of a single module we are now going
to describe, how a system is build. In order to simulate a network of
modules with SystemC each port of each module has to be connected to
it’s counterpart. The ports are connected through channels. In SystemC,
channels are used to model communication and implement protocols. In our
case the channels are implementing the communication.

In order to run the simulation, SystemC requires a function called
sc\_main that is the main function for the system designer. Within this
main function the instances of the modules and the connection of the
modules is taken care of. *At the current state, the tool doesn’t
support hierarchical networks. Hence, everything has to be declared on
the top-level, which is the main.* We call the set of module instance
and the connecting channels “Model”.

Line 5 in Listing \[lst:example\_1\_main\] shows the instantiation of
the module “Example1” with the instance and variable name
“example\_module”. The designer is free to create as many instances of
modules as necessary and each module has it’s own thread during the
simulation.

    int sc_main(int, char **) {
        //Generating/Receiving messages
        Stimuli stimuli("stimuli");
        //Module
        Example1 example_module("example_module");
        //Channels
        Blocking<int> blocking_channel2("blocking_channel2");
        Shared<bool> shared_channel("blocking_channel");
        Blocking<int> blocking_channel1("blocking_channel1");

        //Connect example_module output to stimuli input
        stimuli.block_in(blocking_channel1);
        example_module.block_out(blocking_channel1);

        //Connect example_module input to stimuli output
        stimuli.block_out(blocking_channel2);
        example_module.block_in(blocking_channel2);

        //Connect shared ports
        example_module.share_out(shared_channel);
        stimuli.share_in(shared_channel);

        sc_start(); //Start simulation
        return 0;
    }

After creating the instances of the desired modules, the input and
output ports have to be connected. The ports are connected through
channels. We’ve created a channel for each interface and the user is
required to use this channels in order to work with SCAM. Line 7 shows
the declaration of a Blocking channel of datatype *int*. This channel is
used to connect the input port “block\_in” of module stimuli to the
outport *block\_out* of module example\_module in line 12 and 13. For
now it’s required that each channel has exactly one input and one
output.

After connecting each port to it’s counterpart the simulation is started
by using the macro sc\_start(). The simulation runs until either no
thread is executable anymore (deadlock) or the user stops the
simulation, for example by calling sc\_stop() within one of the threads.
The sc\_main.cpp may be used as input to SCAM.

Propderty-Driven Development {#sec:pdd}
============================

In order to work with the PDD in practice it’s important that the
system-level designer and the rt-level designer understand the required
steps, as shown in Figure \[fig:PDD-overview\], in more detail. The
first step is the refinement of the model, afterwards the properties are
generated and lastly, the hardware is designed. Step one and two are
automatically done by *SCAM*, this is why we are going to provide a
basic idea of what happens within SCAM. For the last step you are
provided with a possible RT implementation that matches the system-level
behaviour.

Step 1: Model analysis
----------------------

[L]{}[0.25]{}

![image](fig/step1_detail){width="25.00000%"}

The analysis of the SystemC model is divided in two steps as shown
Figure \[fig:step1-detail\]. The first step is parsing the model and the
second analysing for compliance with the SystemC-PPA subset and
afterwards creation of the abstract model (AM), that is datastructure
storing an abstract representation of the SystemC-PPA description.

For parsing the opensource compiler llvm/clang is used, as explained in
[@2013-KaushikPatel]. The main reason to use clang as the parser is that
the resulting abstract-syntax-tree
([AST](https://en.wikipedia.org/wiki/Abstract_syntax_tree)) is
implementing a design pattern called [visitor
pattern](https://en.wikipedia.org/wiki/Visitor_pattern) that allows an
easy analysis of the resulting AST. An AST represents a piece of code in
a tree-like structure, which contains all information related to the C++
program, including the SystemC-Scheduler.

In the second step the AST is analysed and all information that is
required for property generation is extracted. In a nutshell, all C++
specific details, for example the SystemC scheduler, are stripped away
and only information that is required to describe a module in terms of
structure and behaviour is stored in the AM. During this analysis it’s
also checked whether the modules are compliant with our SystemC-PPA
subset and the feedback for the designer is generated otherwise.
Everything that is not a valid statement won’t be stored in the AM.
Thus, it’s really **important** that the user checks the errors/warnings
before implementing the code. Otherwise, the abstract module may behave
different then the SystemC description. If the tool doesn’t show any
errors or errors are negligible then the provided SystemC description is
considered to be a SystemC-PPA.

The code for parsing and analysing can be found *src/ParseSystemC* and
the abstract model is described in *src/Model*. The class
*src/ParseSystemC/ModelFactory* is the core element for creating the
abstract model. It’s not recommended to change any code of the factory
without exhaustive testing, because all backends rely on a correctly
generated model. The model is again an AST implementing the visitor
pattern. After the generation of the model the user may write a backend
in form of a visitor pattern. A detailed description on writing your own
backend may be found in *src/Backend/*.

Step 2: Property generation {#step-2-property-generation}
---------------------------

[L]{}[0.25]{}

![image](fig/step2_detail){width="25.00000%"}

For now, the AM contains information about ports, variables and a
control flow graph (CFG) describing the behaviour, where each statement
of the code, assignments, communication calls and if-then-else blocks,
is represented by a node in the CFG. There is an edge between two nodes
if a statement is the successor of another statement and the
if-then-else statement has two successors.

A major benefit of the PDD is that a sound relationship between a
system-level model and a rtl implementation is established. The two
models are considered sound if they show the same I/O behaviour for the
same input sequence. In order to ensure soundness the abstract model is
transformed into a statemachine (PPA) with states being communications
calls and transitions represent a path in the CFG between two
communication calls. From this statemachine the properties are
generated. Figure \[fig:step2-detail\] shows an overview of the desired
transformation flow, which includes two steps: *colouring* and *path
finding*.

[R]{}[0.5]{} \[fig:system-c-example-complex\]

    enum status_t {in_frame, oof_frame};
    struct msg_t {status_t status; int data; };
    SC_MODULE(Example) {
    SC_CTOR(Example):
     nextsection(idle){SC_THREAD(fsm)};
    enum Sections{idle,frame_start,frame_data};
    Sections section,nextsection;
    blocking_in<msg_t> b_in;
    master_out<int>m_out;
    shared_out<bool> s_out;
    int cnt;bool ready;msg_t msg;
    void fsm(){
     while(true) {
      section = nextsection;
      if(section == idle) {
       s_out->set(false);
       b_in->read(msg);
       if(msg.status == in_frame){
        s_out->set(true);
        nextsection=frame_start;
        cnt = 3;
        }
      }else if(section==frame_start){
       m_out->write(cnt);
       cnt = cnt - 1;
       if (cnt == 0) {
        cnt = 15;
        nextsection=frame_data;
       }
      }else if(section == frame_data){
       ready = b_in->nb_read(msg);
       if (!ready) {
        m_out->write(msg.data);
        if(cnt == 0){nextsection = idle;}
        cnt = cnt - 1;
       }
      }
     }}};

For explaining the details of the transformation the example of
Figure \[fig:system-c-example-complex\] is used. The module describes a
hardware that waits for the start of a data frame. This behaviour is
described in the section idle. As long as no new frame is detected the
hardware stays in the section idle. After the detection of a new frame a
shared output is set to true and the module changes to section start.
The module stays in this message until the master out port did sent the
messages 3,2, and 1. Then the module switches to the section frame\_data
and reads 15 frames. After completion the module goes back to the
section idle and waits for a new message.

This behavioural description is now transformed into a state machine.
The starting point is a CFG of the thread *fsm()* generated by clang.
This thread is then transformed into a simpliefied CFG as shown in
Figure \[fig:cfg\_colored\]. A simplification is possible, because it’s
known that the thread is SystemC-PPA compliant and thus follows a
specific structure. This allows removing all CFG nodes for the
while(true) loop and if-then-else for the sections (if present).

Each node represents a line in the source code, e.g., *L.16*, stands for
the line 16 in Figure \[fig:system-c-example-complex\] and furthermore
is the first statment executed after reset. Execution continues with
*L.17* and afterwards *L.18*. This statement is an if-then-else
statement and if the condition evaluates to false, the section remains
the same and execution continues with execution line 16. This results in
an edge from *L.18* to *L.16*. Otherwise the execution continues with
the true branch. During the simplification, line 20 is removed from the
CFG and *L.21* is redirected to the first statement of section
*frame\_start*. Removing the nextesection assignment of line 34 results
in a duplication of *L.35*, because the successor of *L.35* is dependent
on the evaluation of *L.34*. Either execution continues with section
*idle* or section *frame\_data*.

**Step 1: Marking**

The nodes that are marked red in Figure \[fig:cfg\_colored\] indicate a
communication call. In order to find the communication calls the graph
is searched. Here, we are only interested in communication that
implement a synchronization and the respective nodes are marked. The
result of this are the states of PPA.

**Step 2: Path finding**

[L]{}[0.25]{}

    assume:
    	state == L.17 and
    	sync == true and 	
    	msg.status == in_frame;
    prove: 
    	state == L.24
    	s_out == true;
    	cnt == 3;

Now, all possible paths starting in a communication and ending in the
next communication are computed. Each paths describes a transition of
the FSM and results in an operation and therby each possible path
between two communications is covered by an operation. Operations are
described as interval properties and are checked by the means of
interval property checking (IPC). The operations have assumptions and
commitments. If the assumptions are true, hence the operation
*triggers*, the property checker proves or disapproves the commitments.

For example, starting in *L.17* there are two paths
*P1*$=\{L.17\rightarrow L.18\rightarrow L.16\rightarrow L.17\}$ and
other path
*P2*$=\{L.17\rightarrow L.18\rightarrow L.19\rightarrow L.21\rightarrow L.24\}$.
*P1* is executed if the condition of the ITE of *L.18* evaluate to
false, otherwise *P2* is executed. Figure \[fig:exampler\_operation\]
show an abstract view of the operation *P2*. The assume part shows the
trigger conditions, the component is in the control state *L17* and
there is a new value (sync $==$ true) and the message status is
in\_frame then the component has to: transition to state *L.24*, the
value of the shared port is set to true and the counter is equal to 3.

[L]{}[0.35]{}

![image](fig/example_cfg_colored.pdf){width="35.00000%"}

Installation {#sec:installation}
============

Download the most current version of SCAM:

    git clone git@bordeaux.eit.uni-kl.de:SCAM
    cd SCAM
    git fetch --all
    git pull origin master

Before installing SCAM, open install/install.sh and provide the path to
SCAM, CMake and Python at the top of the file afterwards run the shell
script. The binary will be copied to bin/ and if space is an issue the
installation folder may be removed afterwards.

Requirement for installing SCAM are:

-   CMake, minimum 3.0

-   unzip

-   g++, minimum 4.8

FAQ
===

-   **The property generation takes a very long time/doesn’t finish:**
    Please try to split up your design in various sections. This helps
    the tool during property generation. The best practice is to put
    each communication call into one section.
