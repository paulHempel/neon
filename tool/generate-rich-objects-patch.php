#!/usr/bin/env php
<?php

declare(strict_types=1);

include('external/nextcloud-server/lib/public/RichObjectStrings/Definitions.php');
$definitions = (new OCP\RichObjectStrings\Definitions())->definitions;

/*
TODO: Use this more complex patch once discriminator support is back.

$schemas = [];
$discriminatorSchema = [
    'oneOf' => [],
    'discriminator' => [
        'propertyName' => 'type',
        'mapping' => [],
    ],
];

foreach ($definitions as $type => $object) {
    $schema = [
        'type' => 'object',
    ];

    $required = ['type'];
    $properties = [
        'type' => [
            'type' => 'string',
        ],
    ];

    foreach ($object['parameters'] as $name => $parameter) {
        if ($parameter['required'] === true) {
            $required[] = $name;
        }

        $properties[$name] = [
            'type' => 'string',
            'description' => $parameter['description'],
            'example' => $parameter['example'],
        ];
    }

    $schema['required'] = $required;
    $schema['properties'] = $properties;

    $schemaName = 'RichObjectParameter' . ucfirst(str_replace('-', '', ucwords($type, '-')));
    $schemas[$schemaName] = $schema;

    $discriminatorSchema['oneOf'][] = [
        '$ref' => '#/components/schemas/' . $schemaName,
    ];
    $discriminatorSchema['discriminator']['mapping'][$type] = '#/components/schemas/' . $schemaName;
}

$schemas['RichObjectParameter'] = $discriminatorSchema;

$patch = [
    [
        'op' => 'replace',
        'path' => '/components/schemas/ChatMessage/properties/messageParameters/additionalProperties',
        'value' => [
            '$ref' => '#/components/schemas/RichObjectParameter',
        ],
    ]
];
foreach ($schemas as $name => $schema) {
    $patch[] = [
        'op' => 'add',
        'path' => '/components/schemas/' . $name,
        'value' => $schema,
    ];
}
*/

$properties = [
    'type' => [
        'type' => 'string',
        'enum' => array_keys($definitions),
    ],
    'id' => ['type' => 'string'],
    'name' => ['type' => 'string'],
];

foreach ($definitions as $type => $object) {
    foreach ($object['parameters'] as $name => $parameter) {
        $properties[$name] ??= ['type' => 'string'];
    }
}

// TODO: Add these to the definitions
$properties['type']['enum'][] = 'group';
$properties['etag'] = ['type' => 'string'];
$properties['width'] = ['type' => 'string'];
$properties['height'] = ['type' => 'string'];

$patch = [
    [
        'op' => 'replace',
        'path' => '/components/schemas/BaseMessage/properties/messageParameters/additionalProperties',
        'value' => [
            '$ref' => '#/components/schemas/RichObjectParameter',
        ],
    ],
    [
        'op' => 'add',
        'path' => '/components/schemas/RichObjectParameter',
        'value' => [
            'type' => 'object',
            'required' => ['type', 'id', 'name'],
            'properties' => $properties,
        ],
    ],
];

file_put_contents('packages/nextcloud/lib/src/patches/spreed/1-rich-objects.json', json_encode($patch, JSON_THROW_ON_ERROR | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT));
