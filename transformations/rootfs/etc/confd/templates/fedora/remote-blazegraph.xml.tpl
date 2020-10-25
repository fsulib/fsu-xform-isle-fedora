<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
    	http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-3.0.xsd">

	<import resource="classpath:org/trippi/impl/sesame/base-context.xml" />

	<context:component-scan base-package="org.trippi.impl.sesame" />

	<!--
		XXX: Blazegraph appears to have a bug when left to instantiate its
		HTTPClient and executors on its own, so let's manage them for it.
	 -->
	<bean id="httpClientConfigurator"
		class="com.bigdata.rdf.sail.webapp.client.HttpClientConfigurator"
		factory-method="getInstance" />
	<bean id="httpClient" factory-bean="httpClientConfigurator"
		factory-method="newInstance" destroy-method="close" />
	<bean id="executorPool" class="java.util.concurrent.Executors"
		factory-method="newCachedThreadPool" destroy-method="shutdownNow">
		<constructor-arg>
			<bean class="com.bigdata.rdf.sail.webapp.client.DaemonThreadFactory"
				factory-method="defaultThreadFactory" />
		</constructor-arg>
	</bean>

	<bean id="remoteRepoFactory"
		class="com.bigdata.rdf.sail.webapp.client.RemoteRepositoryManager"
		destroy-method="close">
        <!-- Assumes Blazegraph/Bigdata is running on {{getv "/blazegraph/endpoint"}}:8080. -->
		<constructor-arg type="java.lang.String"
            value="http://{{getv "/blazegraph/endpoint"}}:8080/blazegraph" />
                <constructor-arg type="boolean" value="false"/>
		<constructor-arg ref="httpClient" />
		<constructor-arg ref="executorPool" />
	</bean>

	<bean id="remoteRepo" factory-bean="remoteRepoFactory"
		factory-method="getRepositoryForDefaultNamespace" />

	<bean id="trippiSailRepository" factory-bean="remoteRepo"
		factory-method="getBigdataSailRemoteRepository" destroy-method="shutDown" />

	<bean class="org.trippi.impl.sesame.SesameSession" scope="prototype" >
		<constructor-arg ref="trippiSailRepository" />
		<constructor-arg ref="org.trippi.AliasManager" />
		<constructor-arg value="fedora://model#" />
		<constructor-arg value="ri" />
	</bean>

	<!-- XXX: The ResourceIndexModule looks for a bean explicitly named "org.trippi.TriplestoreConnector", 
		so let us create an alias for our base to match. -->
	<alias name="org.trippi.impl.sesame.SesameConnector" alias="org.trippi.TriplestoreConnector" />
</beans>
