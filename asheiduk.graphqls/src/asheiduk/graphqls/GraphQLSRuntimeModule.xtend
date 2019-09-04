package asheiduk.graphqls

import asheiduk.graphqls.services.GraphQLTerminalConverters

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
class GraphQLSRuntimeModule extends AbstractGraphQLSRuntimeModule {
	
	override bindIValueConverterService() {
		return GraphQLTerminalConverters
	}
}
